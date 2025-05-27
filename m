Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45171280023;
	Tue, 27 May 2025 17:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366720; cv=none; b=iwXt4e6XA1S+TqWWG63e0x2PWgO5Ks3b2Li0dEzZjB48ZAuY9FzIGxri98b3FC0mBvKGtnRCs8Fpme2iAeE8qD6vMbIaUtKXB8giUWz/oi4AgP8TVlJCIa5ELVYNQkqj/4MIu2vTj6fRKpCI680Z4A8XFZQZ+0nip04VXTJSQFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366720; c=relaxed/simple;
	bh=pQgLUgArC9Lomgx0xDJpBzDPTj5cQCqZ8McAAN1ut6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qeyu68gywyFE7BUpd9roPQytmgJEW7Ol00LSxdzmC8qJSXZeNS9hEAIX59hAucemFktmy5cWRnxD7L2vaw2IdNyinTFHYqXEt9muBk4+NLEDATpxn3+bi5ainotCekS6Xjq2qAWgrwHKdUEIrEXkM/uq9mvIT54U+Ejie8MPWDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zk0kEv+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zk0kEv+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A977EC4CEEB;
	Tue, 27 May 2025 17:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366720;
	bh=pQgLUgArC9Lomgx0xDJpBzDPTj5cQCqZ8McAAN1ut6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zk0kEv+aC/JdeyowPQII9bF7JRtEW6V8Z5yqb2egRbLCmMJOZ31rT/aMHRKXc74+3
	 4jVNRBh5bF+7t6rTxlplodS3m+UUueVMOj4AxtfL3KboI3WjTrvYu66YmyYrPiD6Kk
	 YwFPvSAzLDZU93szrktdhQD+dli/uVDy9pcmD/dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 160/783] scsi: st: ERASE does not change tape location
Date: Tue, 27 May 2025 18:19:17 +0200
Message-ID: <20250527162519.684125175@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit ad77cebf97bd42c93ab4e3bffd09f2b905c1959a ]

The SCSI ERASE command erases from the current position onwards.  Don't
clear the position variables.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20250311112516.5548-3-Kai.Makisara@kolumbus.fi
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 2a18ba51427ac..4add423f2f415 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2897,7 +2897,6 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->long_timeout * 8;
 
 		DEBC_printk(STp, "Erasing tape.\n");
-		fileno = blkno = at_sm = 0;
 		break;
 	case MTSETBLK:		/* Set block length */
 	case MTSETDENSITY:	/* Set tape density */
-- 
2.39.5



