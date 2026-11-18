Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053293;
	b=T0dJoyO7uAP9rKipIq8QHXo4/5qg2IdFiFxw79iBtkLj3cRXdmmov3WvSEYv9CIo9t2/
	 5GtNR2leTqHtVu7oZPh1LzPzpRpqthtMa+7Sz86JN3rEe95EBL01TpvH62Nqxgv/riwCW
	 Dti7IRZJMgPl5+PAFZTPpn4hTiP/8InsUn5fhQoEIwSbkiYjcbtGON2F1ECG3hzMaGIqf
	 ncRx9rfyGTUlLw5q3CM6I5dwd6fjkFh1Ph32zMllTjYhqbPFbHOOSu+iztrSVCLi/xHCs
	 lQ+YvOSJdoyrHEUnRH+9pjTibBSq2fJclx/uoOOtokDwyB7UxI9rE7ZUhf8H1gb4Y4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=It5dADaYC6ouj4EYOeehNBUkFfCiL9mkPADqT3QLjF8=;
	b=Zme6DSmAE7wIFvZRAf3oZ3J4EWl816dFBxOlhNRVDVRrbT5IeCUpb/NLji4sybOax7Fk
	 1r8EEnfDxUDV4624mKb2oTbtWZuvnioJWUaMlkFimnzNva3+JbeBpJJzMoFtXrIOfgAu+
	 5Sjf80Fi1G/k2+6AXy2t3MPb9xeGBxVjeurAzODknv7sPxJT76x/du9/+O1mzeKrZA3Ni
	 HFwYwAFlE+tDMowFKZDR5TfcFnNvWVgKBGa1D9ZUVUie60+pJw2SvK/6H3iGjqTSFpXYk
	 z0nWJKpDMISoUu6kPLu0OX3f/LWmctolcrzJ7X3D4Nfb5jdQy+/j9PjXGPnMpL3gMqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIAWsebA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4684C606A336;
	Thu, 19 Nov 2026 01:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIAWsebA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8211F000C7;
	Thu, 19 Nov 2026 01:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053293;
	bh=It5dADaYC6ouj4EYOeehNBUkFfCiL9mkPADqT3QLjF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIAWsebAOKve84I3xJVxIbIADFfAeyeOhTryiWxpeicJt+kFFy7n13sJSnBU6/IqE
	 PhCqftSGrzbAfeqIkfwpCuZHQHobEf79KmXuHbzqazASqVvsXIX3+HRJo6g3WJLtAl
	 VUc2/dXxo246FsiVnjG6jnTONeKKeEtLE0CyBCHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0867/2214] vringh: reject empty / undersized indirect descriptor tables
Date: Wed, 18 Nov 2026 15:42:23 +0100
Message-ID: <20261118150046.819543077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fang Xieyan <fangxy@xiaopeng.com>

[ Upstream commit 60a792b97933a686316737838cd007d27963011e ]

move_to_indirect() validates an indirect descriptor table only with
"len % sizeof(struct vring_desc)".  A descriptor flagged
VRING_DESC_F_INDIRECT with len == 0 passes that test, so *desc_max is
set to 0 while *descs points at the empty table.  __vringh_iov() then
copies one struct vring_desc from descs[0] -- 16 bytes past the end of
the table -- before the "indirect_count > desc_max" loop detection
aborts the walk.  The over-read value is discarded when the walk aborts
and is never used to map anything, but the access itself is out of
bounds.

Reject any len smaller than one descriptor, alongside the existing
stride check, so an empty table is refused with -EINVAL and no
descriptor is ever fetched from it.

Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
Cc: stable@vger.kernel.org
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Message-ID: <20260926160755.21485-1-fangxy@xiaopeng.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 37b4ca96c5276..71ed480dbbc8e 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -197,8 +197,9 @@ static int move_to_indirect(const struct vringh *vrh,
 	}
 
 	len = vringh32_to_cpu(vrh, desc->len);
-	if (unlikely(len % sizeof(struct vring_desc))) {
-		vringh_bad("Strange indirect len %u", desc->len);
+	if (unlikely(len < sizeof(struct vring_desc) ||
+		     len % sizeof(struct vring_desc))) {
+		vringh_bad("Invalid indirect len %u", desc->len);
 		return -EINVAL;
 	}
 
-- 
2.53.0



