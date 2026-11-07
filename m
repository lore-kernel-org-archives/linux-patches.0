Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064149;
	b=LNtRUiysKKOGdKfb+UuvFOeoQG3cBUxeAUghSkBcXLvAX8nDvONP6Iyj3ONu+btk9JIY
	 OcnXBw7ygwwcly10lC8KN6y9EZhNvcUdcLBMheF3Op64ugC4YKZG2HU9F1MkCSrYdtkbH
	 4DwMpKSNHxmMuRKXjJD8XwzYQpiyyYko53DSuQ7UzMxn6D6yf1Y7IPnTIYH4720U5dt/T
	 PNOsRjeb8BAQx0NgMke1kpkGkYt8eaPoSzFPBYfOLBnmFJegVzjbToeSMpM26p4Dk+bit
	 uXFBIC1j8ZiSgYBfbcLZnNTwgReMmAjdib3kC+F5ox08fB/W6Vu5mWCd6ANpS19w2hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VxNLJdBp5AhCFvTbEb1Fslk5U2WOn0f/O2BhW8JSbwk=;
	b=PGiVbUSvt8nUyOLYwqqTwU+4C/6mhFRHNcK63te1U971v7x1YJ6rHdVI3mlWMpRqQOUO
	 HqSietNRhgHwG/PaD67oN+n4VvzSJjU6I2sLVPrW/3lJpAYCDSOtcy7Ls9zsukfPVv6Fo
	 ZmjURrNWXwXXZNe3C0ivEWyVU8Ndcc8GSehlyXzHAqrFe9M/oWlrGZ8EsGu06OnGZUFhj
	 wWOlPWue0I2xWmUSZ7bcdYZ6EwvXQFbGuQMbkCe1zluX6GX/l4StWySjYyQNqk0GrVpzR
	 pZdj9zficrib93JnXl3SiecWa2D3SeKiVktTi7E4FBBYz/SE8Hu8QRTrRb4kJPFSpIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7FmrJXM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2A2606A33F;
	Sat,  7 Nov 2026 15:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7FmrJXM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6561F008A3;
	Sat,  7 Nov 2026 15:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064149;
	bh=VxNLJdBp5AhCFvTbEb1Fslk5U2WOn0f/O2BhW8JSbwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7FmrJXMiZtyrxPLACQNXQqIIZ69rd6kHVEAIl1lCQRE6GEp8UgFlev7H6GItuOuG
	 yRvNVEWQ4edVYqL3kG/7c89gqMYuy2/YurN7Nj3jQORkVjI3hSuDKdUkirsrZbaA/h
	 6IqHAb4jloylY2kVbkANDI3BiuzqdTHKKBQWnY60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0257/1257] crypto: qat - zero the VF migration state buffer on save
Date: Sat,  7 Nov 2026 08:42:33 -0500
Message-ID: <20261107134946.601065186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 5d504e65516dde8c88117378292e9c78f3d2cf58 ]

The QAT VF migration state buffer is allocated with kmalloc(), while
qat_vf_save_state() exposes all state_size bytes to userspace. The state
manager writes only the serialized sections, leaving the unused tail
unchanged. The first save can therefore disclose stale heap contents,
and subsequent saves can disclose data left by an earlier migration.

Zero the whole buffer before writing the setup data. Once the setup data
is present, preserve it and zero the remaining state area before each
state save.

Fixes: f0bbfc391aa7 ("crypto: qat - implement interface for live migration")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
index bf2bae78a40d5..d8b961b2f2f7f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
@@ -837,6 +837,9 @@ static int adf_gen4_vfmig_save_state(struct qat_mig_dev *mdev)
 		return ret;
 	}
 
+	memset(mdev->state + mdev->setup_size, 0,
+	       mdev->state_size - mdev->setup_size);
+
 	adf_mstate_mgr_init(vfmig->mstate_mgr, mdev->state + mdev->setup_size,
 			    mdev->state_size - mdev->setup_size);
 	if (!adf_mstate_preamble_add(vfmig->mstate_mgr))
@@ -934,6 +937,8 @@ static int adf_gen4_vfmig_save_setup(struct qat_mig_dev *mdev)
 	if (mdev->setup_size)
 		return 0;
 
+	memset(mdev->state, 0, mdev->state_size);
+
 	adf_mstate_mgr_init(vfmig->mstate_mgr, mdev->state, mdev->state_size);
 	if (!adf_mstate_preamble_add(vfmig->mstate_mgr))
 		return -EINVAL;
-- 
2.53.0



