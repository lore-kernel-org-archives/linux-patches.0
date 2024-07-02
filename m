Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E343D978;
	Tue,  2 Jul 2024 17:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940730; cv=none; b=Zy0/iD43bZeHyZPB9PkggJ5u0CWQL+rPQHodqiK/1R8Gzc7ZyKFz4X+oZu0fFkFbBUwapFLR787dfVIv+zKuiGN5zUGnBRYCQ1Qir99DZQXP/VBWoC7AhjXGenzVInpSYL+tGSJmEY9kwLcQ5CTOo+bdwnw/0aooM6ksfo8VLAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940730; c=relaxed/simple;
	bh=vEeE3tZyLN6tMyWZjxS9cBLTEW0HGczKfPl2wiiV3fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYaqg7B6mdH/zNdjmX39ZmUHg/WxF6tigluF7skRdPwyMdlEws0w29HoMNOsbYRka6XhlFH9oF3qdyQ4cwEosxYKYbmRPaWl9eSRG0akA175oiIiPDpD0loBVbYsCYSkdEfoz78jPghnN7pMLAg9lr/VQX5DazTLRBPoaSP1/+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SweLAIFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SweLAIFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D435C116B1;
	Tue,  2 Jul 2024 17:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940729;
	bh=vEeE3tZyLN6tMyWZjxS9cBLTEW0HGczKfPl2wiiV3fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SweLAIFLDRZ8mVxESFiCnRYs6K/R5j3COSIicWfAS/vOValm0lA8NoGKs4c5w/ihf
	 QJ09b0AcvPdSdpff/Gg2R0LWIxKmKx13jdVgSjDl2UnxGn07eSe0Hi+Rgvfk6fyTJc
	 86RFryp0WUonKZKvcaLAjVG3wuCT/acXd03/Rs+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenchao Hao <haowenchao22@gmail.com>,
	Audra Mitchell <audra@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/163] workqueue: Increase worker descs length to 32
Date: Tue,  2 Jul 2024 19:02:14 +0200
Message-ID: <20240702170233.822893251@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenchao Hao <haowenchao22@gmail.com>

[ Upstream commit 231035f18d6b80e5c28732a20872398116a54ecd ]

Commit 31c89007285d ("workqueue.c: Increase workqueue name length")
increased WQ_NAME_LEN from 24 to 32, but forget to increase
WORKER_DESC_LEN, which would cause truncation when setting kworker's
desc from workqueue_struct's name, process_one_work() for example.

Fixes: 31c89007285d ("workqueue.c: Increase workqueue name length")

Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
CC: Audra Mitchell <audra@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/workqueue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 24b1e5070f4d4..52c6dd6d80ac0 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -84,7 +84,7 @@ enum {
 	WORK_BUSY_RUNNING	= 1 << 1,
 
 	/* maximum string length for set_worker_desc() */
-	WORKER_DESC_LEN		= 24,
+	WORKER_DESC_LEN		= 32,
 };
 
 /* Convenience constants - of type 'unsigned long', not 'enum'! */
-- 
2.43.0



