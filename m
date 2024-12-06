Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258CA149E0E;
	Fri,  6 Dec 2024 14:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496240; cv=none; b=QsS+Mv+ED7Th3BVI7lSXoLtSpCMjQRgHsapxa/ghmPI3rooJpzSYyOLrdWIvQuV87uf8cKNY2/784be7jpR53U04ySZ22uai5Rq1VawP5TiPPZpyn8DB5UxfSapCk6TIVGGHPbwpJzeC0dG/ODbCyecTwyeiS1dJI4a4WFc36wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496240; c=relaxed/simple;
	bh=tUzyj2wndSTBhzjI56oUoODovjQgbtzOWyJ0WEiBe1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcZnuULI6AN63A3fQau/IFRdHISg1QO14Kg3bAmpvXio90ZK/Oiy6yGdYzbIB9vbj6AnZZaMUXvgSkZnXBByBQvYpYEN0185PP5cUWo+GazSZDrQBRh8DiYgpOcfNdyUT4YqQKqGssXE+MATQ+nP7Pxva44ARRusclo8vfE5E3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjlrf8tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjlrf8tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0162C4CED1;
	Fri,  6 Dec 2024 14:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496240;
	bh=tUzyj2wndSTBhzjI56oUoODovjQgbtzOWyJ0WEiBe1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjlrf8twgoyFsgGDoQcqqeoeD+Ot03PheIEs/YjA+UY8vVfzl0VSePorxLiGFyIxf
	 euiW5KlHu7RQrI5JYHiFJS/Y9KBKrXxn57QBuuvASFzVYkIxKH7u1PBHTzKScIfnl7
	 dmQnXJDBFGhv1N9sKHzKCNMhJDYQZXoJD4lLMLbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ssuhung Yeh <ssuhung@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 094/146] dm: Fix typo in error message
Date: Fri,  6 Dec 2024 15:37:05 +0100
Message-ID: <20241206143531.275339128@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ssuhung Yeh <ssuhung@gmail.com>

commit 2deb70d3e66d538404d9e71bff236e6d260da66e upstream.

Remove the redundant "i" at the beginning of the error message. This "i"
came from commit 1c1318866928 ("dm: prefer
'"%s...", __func__'"), the "i" is accidentally left.

Signed-off-by: Ssuhung Yeh <ssuhung@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 1c1318866928 ("dm: prefer '"%s...", __func__'")
Cc: stable@vger.kernel.org	# v6.3+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-space-map-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -51,7 +51,7 @@ static int index_check(const struct dm_b
 					       block_size - sizeof(__le32),
 					       INDEX_CSUM_XOR));
 	if (csum_disk != mi_le->csum) {
-		DMERR_LIMIT("i%s failed: csum %u != wanted %u", __func__,
+		DMERR_LIMIT("%s failed: csum %u != wanted %u", __func__,
 			    le32_to_cpu(csum_disk), le32_to_cpu(mi_le->csum));
 		return -EILSEQ;
 	}


