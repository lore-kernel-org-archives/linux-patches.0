Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033672;
	b=HNZovggjpUpE4abUjdNUqg5pI3FORicMvGK9v/hCFTnq/jY3Wz0S3qbOfhvNV/Bd+76z
	 MAmPW1oxQkxy9kYw0BoDtOJVqJLE0fIcGO8Un6j7u/wM0Pegd5DlVIFiZF5gLljQV+Np/
	 GjeC2cV+6o4iUHBxIbKVGPVjSP47+20n16xd86dE8N+oQePbfr4YVgVksjbBsdzl7x9dt
	 haNs3HrTDmVLlBN1Wid6nbxzksg48MFWbuHFY7QxQ28auNzNuCmMnbk+4SFEcCe/p3d1Q
	 OCFp7LJAqRbmRZfIARCx4M7z/CWn7uRIldEejqwOR9X7BSKFFR/5g9V5idvhKN7iP/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BaBZ0Yhw6uG07mSEUOgWLS7f6BBW42TTtCe18f8RQjw=;
	b=4DXste5Apw6zHPSbvTMgkDeMgeeokCbh8I7lcNAGkGAVgPObzm00Y20cvhHzuAxNJ4r7
	 5gE/4WcbKpFlIDrK57X/qS5aN2yXbGiieAjmsspOhlsH2rkht+8sjIhUm/pPpz1gPiJhJ
	 pbQ9jHPur/lpMVXmZyw+HDVhaEntxewiQILrqsZKej4dEpAtt0M48d38w00vqB8BUdg7E
	 lunLmsXbNTOdth757vXbgcEnW1pjBwONhHzZhHV+pQmiDCIpmZm90XTS6PuLF/ZzwPYR4
	 7RlaiPpdDmTrxufY88i2ct2LO3fBLItT9xSKACoEzx0rCynjhMtHpmeU6bPyKWfQPfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NrnnxE2N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C29606A32A;
	Wed, 18 Nov 2026 20:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NrnnxE2N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C004F1F000C4;
	Wed, 18 Nov 2026 20:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033672;
	bh=BaBZ0Yhw6uG07mSEUOgWLS7f6BBW42TTtCe18f8RQjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NrnnxE2NOx8mY3kOax/9R9A3CgYtLbjwAFJ7w0f5J6smIQu7IBLtt+m8OccjNfWX6
	 N+NzORg7jrA3Z8Dtz9IALJW2m4GR6PwGepqfX5b3HYD7/wgp84vx3F4ibl98Yfave1
	 w9M9w0VaJMDDvDyj4yfszkTxV27PMNsyZBfvqEFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0098/3318] media: em28xx: dev_info->pr_info since dev has been freed
Date: Wed, 18 Nov 2026 15:12:00 +0100
Message-ID: <20261118150317.143638154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit c132b07f7e5853c0df35a9b94b8e204cdc6afdef ]

In em28xx_free_device() dev_info passed &dev->intf->dev,
but that device can be freed already.

Just use pr_info instead.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Tested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 62887cf6afa5d..a835084914802 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3504,7 +3504,7 @@ void em28xx_free_device(struct kref *ref)
 {
 	struct em28xx *dev = kref_to_dev(ref);
 
-	dev_info(&dev->intf->dev, "Freeing device\n");
+	pr_info("%s: Freeing device\n", dev->name);
 
 	if (!dev->disconnected)
 		em28xx_release_resources(dev);
-- 
2.53.0



