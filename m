Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623714;
	b=NYQ6J4nRnnRLGyEmL1yX0lWlhK78QZyHy458NMvN0JGN2/Ix04m/jcl/Yq/nzVLXGj/Z
	 LSMI85r6Fry7uIGPpUojgiPXlg/tK5NvfRenoLhdejOsxSoDN46cl4HzyiNvlMDWBES9f
	 YagG4gNuO7HeNbNQKSnW0ZK7EdaPjSCVmvQdj2f14r8NwkYPsKR4k5ChOmE0t6V2mDLx/
	 gTqNJ6VYoNDAV8LVSab27sRrQSZNibl/2cQcTdzrqcnNum1sJrqMG15pluQPfy5elr6Lg
	 mEdjQabJwXADK+ff9ED9QRtFBIdU3RcSubAxZUsxHfhsFfZOdiSbjI6H+U6x2/Wxnbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G8tBsbTMyUk26q0PiZXgkYXkdn12gTFmBJQNRfz4df8=;
	b=YHXVSlk4EQGc0zHSL3b5Jgdfs+X63Xu+VjnAKAWoVAUuFYustCTzDpP8+q4EtWNYVpST
	 20ThyuLyRfXaTL6jk9xt4uHRjkJwnZdR3xolJpN/ivPOCZFJAaQUt0dypG+KE73XfkNWa
	 9RHMnScQsy0eVR3loX7r6CX1jLd4LBJqJDdOrjbizdmVm31kyO4wdLO3mxk3IEdgs3NR2
	 qSWdXBRTNUC4mpDlbTdw0+QVElaqGBRnUjXftHUuc0BYpjJc0p+TdQwG8rReJ+NnSpa+x
	 92N/BuVuKBCVUPxTSUfO+UM+Zi6QFMULtSlznDwnmYEmLfQyFSa+NuQGAO08a/j7QCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fX3cGadA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C17606A321;
	Wed, 25 Nov 2026 16:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fX3cGadA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0651F000D0;
	Wed, 25 Nov 2026 16:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623714;
	bh=G8tBsbTMyUk26q0PiZXgkYXkdn12gTFmBJQNRfz4df8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fX3cGadAYE8AWe7sKNdYEcZVmTWHkRHMFMin+I7kJuOQgnrCupt3hn5S/Y1tK6ykP
	 v1xK0VyLDxMfMeKgZyNs9X5o/1m2ftnigwPch3oIx8sKEHfCvEM/D+e7jAoSAolP/I
	 y2JmuyYnpU6UnOBEI7lDofIvVq5DQtdmlXlELdwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Amer <and.amer@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 947/990] iio: afe: rescale: expose offset if rescaler or source has one
Date: Wed, 25 Nov 2026 15:38:34 +0100
Message-ID: <20261125143844.174308737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Amer <and.amer@gmail.com>

commit c293f0db308fe76a0a9b0f6674cd2dea149b03aa upstream.

A rescale channel advertises IIO_CHAN_INFO_OFFSET only when its own
offset is non-zero. A child rescale therefore hides a source offset,
and consumers apply raw * scale and drop it, even though
rescale_read_raw() folds the source offset in.

Expose the attribute when either the rescaler or the source channel
provides an offset.

Fixes: a29c3283653b ("iio: afe: rescale: add offset support")
Signed-off-by: Andrea Amer <and.amer@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/afe/iio-rescale.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/afe/iio-rescale.c
+++ b/drivers/iio/afe/iio-rescale.c
@@ -304,7 +304,8 @@ static int rescale_configure_channel(str
 	chan->info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
 		BIT(IIO_CHAN_INFO_SCALE);
 
-	if (rescale->offset)
+	if (rescale->offset ||
+	    iio_channel_has_info(schan, IIO_CHAN_INFO_OFFSET))
 		chan->info_mask_separate |= BIT(IIO_CHAN_INFO_OFFSET);
 
 	/*


