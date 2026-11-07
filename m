Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063533;
	b=oO2LWOYdUm+lOqkeguWXWHxNDCXC0VFEL+zZcl2feIzMYj7JL+mDXdV58r1x3eBp5n0P
	 cMVGOzeNanemETokC7KW4QtLz/17sKniwoD5kBNciTXb7eEzBExds2GTfyspXfgV+1rgN
	 KhYX3GxepYVse/UF58FEmUgbsjP8wVEzblxhueN+lsinfvTUYt9A4wXHQykg3Iqz/DApP
	 y1sJLXsYFokkJRLESzU9bcrUM9wrCV/C5SkJquRED6wkqlsLk2ZjPzleWDlHfhv4QR1ue
	 VuhSUX4G/w2KftYzrqyIgC/1P4E22IN5j90g5QrpE1+10jTKWxva3ceT7pQzGzxcbRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VkMmjgVFRA4wU2l0FytPUngDU1cPyk5QczMb+ig14QM=;
	b=gWPseilIVFiK+qfXK5NonTqIt+RTKHLYM+pJeDNBsOxNyXMxn5xuTjkiLp0gkld8sdaV
	 7K3Js3JAENhg6EyKnxECrZZSszzQ8Qayqd8ywpziBpubMYpbt8x6RrZyQ5w6nXZPclUjy
	 /9yU2BI7+hgnXc3bh55L9zNGchq0xDE0N0Vdz3X+OmmjdqOkTbf9nPRkF988BKZ8yETP1
	 9lLiuCgj233XUcEy4j45Nv+PFW9TmS0NW17YNsuJ6inkOZoB9VeKlK0ueEc4IRlHrPWf+
	 9et7phFZuSw5etDpKigdAxEHi6IoxclrtCrGPZxTsccTBW2CPbt1s+Gftp17/KI7PDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyrtCpR2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFBF606EEB8;
	Sat,  7 Nov 2026 14:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyrtCpR2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4BE1F008A3;
	Sat,  7 Nov 2026 14:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063533;
	bh=VkMmjgVFRA4wU2l0FytPUngDU1cPyk5QczMb+ig14QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MyrtCpR20mV0ti48tLEZNXoPkM5awdY/G22I8IzA06MwqJBn1exAyUUSu7po+E6ov
	 d9jPxdqnmXfy81v/nelwf6/qLdEikuIadGpnsbDINUucKYSrft3F2x5ApJXjqza24X
	 Um/uSOCs3BCX0F1YFY9a0lE5UjfeCRlkZEl7X57U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Luigi Lauro <luigi.lauro@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 670/869] drm/amdgpu: require _PR3 for BOCO
Date: Sat,  7 Nov 2026 08:55:52 -0500
Message-ID: <20261107134915.833180785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Luigi Lauro <luigi.lauro@gmail.com>

[ Upstream commit 28f3d169f162ca7e803c5a1f7e1bb55bdc915d1c ]

amdgpu_device_supports_boco() returns true for an AMD_IS_PX device on a
system with a hybrid ATPX method even when the device has no ACPI power
resource (_PR3). On an APU mini PC with a discrete GPU attached over
OCuLink, the iGPU's ATPX method reports hybrid graphics, the dGPU is
flagged AMD_IS_PX, and runtime PM in auto mode picks BOCO:

  amdgpu: ATPX Hybrid Graphics
  amdgpu 0000:c6:00.0: Using BOCO for runtime pm

In BOCO mode the driver leaves powering the device off to the PCI core,
which can only do it through _PR3 on the upstream bridge. No device on
this dGPU's path has _PR3, so when it runtime suspends the card stays
powered, with its fans at about 700 rpm.

Require has_pr3 for BOCO, as the function's description ("dGPU with ACPI
power resources") says. The same card then picks BACO, which powers it
down:

  amdgpu 0000:c6:00.0: Using BACO for runtime pm

This only changes systems with a hybrid ATPX method and no _PR3 on the
dGPU's upstream bridge, where BOCO cannot cut the power today. Tested on
one such system only, an RX 9070 XT (Navi 48) over OCuLink with a Ryzen
AI 9 HX 470, with the change backported to 7.2.9: the stock module logs
"Using BOCO", the patched one "Using BACO"; BACO runtime suspend powers
the card off and it resumes cleanly. Not tested on a hybrid laptop or a
Thunderbolt eGPU.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5980
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luigi Lauro <luigi.lauro@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1a039805354a44aab7abb2a6e685212d48b17a5e)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 88dda7dd2cd1c..4a1b8795d117b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -442,10 +442,8 @@ bool amdgpu_device_supports_boco(struct amdgpu_device *adev)
 	if (!IS_ENABLED(CONFIG_HOTPLUG_PCI_PCIE))
 		return false;
 
-	if (adev->has_pr3 ||
-	    ((adev->flags & AMD_IS_PX) && amdgpu_is_atpx_hybrid()))
-		return true;
-	return false;
+	/* BOCO needs a platform power resource (_PR3) to cut the power */
+	return adev->has_pr3;
 }
 
 /**
-- 
2.53.0



