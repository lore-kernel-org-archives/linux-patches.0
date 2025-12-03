Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B50303A11;
	Wed,  3 Dec 2025 16:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777780; cv=none; b=KAVUzWPWrc5+ldg3SPShu9iKmR8h4fbvNo5R9NheMmlkMkfEMrPkiWDBgKIR8sKU79/UYPhymmZIsM4qc6gOAGRiTj2nWUR19Vi3Pr1rEZs5J7jBlqA5aZl2hItf3PgZsyhQ1nmqgfNzW+Y5l5W5s/i32ZcP39+JvggjUJni49I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777780; c=relaxed/simple;
	bh=W247V04tnVUsEK8D1Z9vWE/6NTEbA/gYeSMmB0jrjAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UW+Glds2UvNLM0vso+lndbY5Og7cE6XcQ62hhAb5PsjQQf39ipjJhco+rVSAIxgQjy7X2Cy7RkirFxO59nR7DcPr+XclO2yfSQLU17/GXKYmc/0zIYifyNL738nzsK1poY38/zskGiOpX9HyNozJdSVp1zT+9P6x66fpnJVa1Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqEXAYcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqEXAYcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E6DC4CEF5;
	Wed,  3 Dec 2025 16:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777780;
	bh=W247V04tnVUsEK8D1Z9vWE/6NTEbA/gYeSMmB0jrjAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqEXAYcYMHiRcZtWhwYBBMipibmht/F5vUk3hWQbTY/Ei+OONGq0qw47VoXBE9M80
	 QgX0leCCI6Za+shMRS+YLr6BoweK9ve0dHDSV3AhWpRTVKBGZbfRDLp2sibTXfSAU0
	 9l+wBUuLOUyiv9ORbxAyvDmpTREAO+yjyAJy/j/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/392] media: redrat3: use int type to store negative error codes
Date: Wed,  3 Dec 2025 16:24:55 +0100
Message-ID: <20251203152419.420789724@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit ecba852dc9f4993f4f894ea1f352564560e19a3e ]

Change "ret" from u8 to int type in redrat3_enable_detector() to store
negative error codes or zero returned by redrat3_send_cmd() and
usb_submit_urb() - this better aligns with the coding standards and
maintains code consistency.

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index cb22316b3f002..6d70b49b524e5 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -422,7 +422,7 @@ static int redrat3_send_cmd(int cmd, struct redrat3_dev *rr3)
 static int redrat3_enable_detector(struct redrat3_dev *rr3)
 {
 	struct device *dev = rr3->dev;
-	u8 ret;
+	int ret;
 
 	ret = redrat3_send_cmd(RR3_RC_DET_ENABLE, rr3);
 	if (ret != 0)
-- 
2.51.0



