Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68B38F5C;
	Mon,  1 Apr 2024 16:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987830; cv=none; b=VBEYyiWFFuxgO8q1zKAOc55tTLDCICPFvWf60Kk5+6XDp0mObVSwhILOh1hQ21x077J6U5+e0Y3JpguJWeDA3ZS0VncjhBnhITu5DhzOf/0JNIBFStZ3lI4hPB/vcVsOKIipdRXzCsbb1YgvOdmOFkxmJpQMhKQt2WwZl1oopU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987830; c=relaxed/simple;
	bh=aMGSdHBxSBmAH63roOmWNt8i0qjdufzq5yWUk4nrBbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrGEXRfmnlsf75+O15TPiHrmdxdwxftABQ8ZrAcloOo6+fDHRbF+RF4Gxq4VEu3K869NS/6nzmvJ/ZKkYwPcPk6CO+VEL9AzNffFOuuZoHARa6qlYYlAF9FXJ6A3jS7w7hTqMsWoJsqlc+axOB6WZY+Y3tImwHHfFg9QJmWWoQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSZD/txc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSZD/txc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25579C433C7;
	Mon,  1 Apr 2024 16:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987830;
	bh=aMGSdHBxSBmAH63roOmWNt8i0qjdufzq5yWUk4nrBbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSZD/txcIkaYaA+Zv9Qon1vShs0ZWdee3RYm/BaSm7KdZ62Uu6Xg0PgL1/q2C3E+w
	 eDr6AmhL9Ey9XgoKv1ajAg+YIt2WXmJeowXClHvD7yGysIz3nAKGXqoYxCNUILK6C5
	 raF41OnrMAix/fQGf/iIcjxaip6VP2bWXO6JvdN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.8 393/399] scsi: lpfc: Correct size for cmdwqe/rspwqe for memset()
Date: Mon,  1 Apr 2024 17:45:59 +0200
Message-ID: <20240401152600.898958073@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit 16cc2ba71b9f6440805aef7f92ba0f031f79b765 upstream.

The cmdwqe and rspwqe are of type lpfc_wqe128. They should be memset() with
the same type.

Fixes: 61910d6a5243 ("scsi: lpfc: SLI path split: Refactor CT paths")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/r/20240304091119.847060-1-usama.anjum@collabora.com
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_bsg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3169,10 +3169,10 @@ lpfc_bsg_diag_loopback_run(struct bsg_jo
 	}
 
 	cmdwqe = &cmdiocbq->wqe;
-	memset(cmdwqe, 0, sizeof(union lpfc_wqe));
+	memset(cmdwqe, 0, sizeof(*cmdwqe));
 	if (phba->sli_rev < LPFC_SLI_REV4) {
 		rspwqe = &rspiocbq->wqe;
-		memset(rspwqe, 0, sizeof(union lpfc_wqe));
+		memset(rspwqe, 0, sizeof(*rspwqe));
 	}
 
 	INIT_LIST_HEAD(&head);


