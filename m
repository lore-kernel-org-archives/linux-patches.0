Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3481412A17F;
	Tue, 23 Jan 2024 00:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968825; cv=none; b=cpTY9PO3QT2zluvqGzX8zPUZbFvxNxP3Q7QN6sgCTNjXy9o8l20JVE3hM84PlK6LZEXst+UNcqb1Vcn7K5uwy8fHEVQbJIrOcFVtl0VwSume59KCN1GUDlTqqR6oSfrOQL7iY7KOT8euUMqDsB6zWC0zVvmOGg6dnQLXha6TAxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968825; c=relaxed/simple;
	bh=jxaj6XBD57FrPjSRZDWlK1oAk9QiylVDLEa35vsCCpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BezFzfvVtlaDvZI+yvjn75g5ZTfmV/JIhKQYRPiwLzljYaaW4odZ12txwKUE01qGKGGEtm6Y4OCO1xFkauo3jq0gk64mMjtGuZmRCki3opzs9ACp2BTdCjKxVkhnOb77MneGPk9vQJfuqagQ2o5G9oNRdgcRhFaUOWzR30+DiE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OypnQINU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OypnQINU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C4BC433C7;
	Tue, 23 Jan 2024 00:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968825;
	bh=jxaj6XBD57FrPjSRZDWlK1oAk9QiylVDLEa35vsCCpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OypnQINU3g2dpYED5sBx7P4EBTIxbuatHFyOBXeOH3JF/wA0KF9KHn14EaKp8Q/kA
	 vP3QV/donR6BUygVnc1ANfnnPQiig94AILqdLHmltActqzMb9sWfxdBuURHpYsZxU/
	 n/bGqMMaZVIQXCZsvMILXFU22oTb0X3CAipPma6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ram Muthiah <rammuthiah@google.com>,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/194] crypto: virtio - dont use default m
Date: Mon, 22 Jan 2024 15:56:31 -0800
Message-ID: <20240122235721.822465805@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ram Muthiah <rammuthiah@google.com>

[ Upstream commit b1a5c9a620f2b1792e51ae3961b16943e4f874f2 ]

Drivers shouldn't be enabled by default unless there is a very good
reason to do so.  There doesn't seem to be any such reason for the
virtio crypto driver, so change it to the default of 'n'.

Signed-off-by: Ram Muthiah <rammuthiah@google.com>
[EB: adjusted commit message]
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: fed93fb62e05 ("crypto: virtio - Handle dataq logic with tasklet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/virtio/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/virtio/Kconfig b/drivers/crypto/virtio/Kconfig
index 01b625e4e5ad..6d3deb025b2a 100644
--- a/drivers/crypto/virtio/Kconfig
+++ b/drivers/crypto/virtio/Kconfig
@@ -5,7 +5,6 @@ config CRYPTO_DEV_VIRTIO
 	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_ENGINE
-	default m
 	help
 	  This driver provides support for virtio crypto device. If you
 	  choose 'M' here, this module will be called virtio_crypto.
-- 
2.43.0



