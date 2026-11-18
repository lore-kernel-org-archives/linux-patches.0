Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036760;
	b=dXfWVymIWc2KQ+KAfuEpaR3uD07ovZgs+x/18R6jNYU2xVyib2scGUgXYgJquLU7xNvg
	 Y/fZe44WI7Sc6vf12My/9yY5yrvNKw/LvSIbQnYZRw7496ou3v8H+3CGbhLSzapjnJX6E
	 rcJZkHtrhrhd4BNHl2VFoSdLvyE8e8ITaKzIfl7zKyNxrYfzy9MyNy/XO1jrBzOJEb0hE
	 J0QFf6nCMcKH5lGVNkmxSpWo5bUtg0mULjDgkaVxhvSoe616lVp+GQQ7i1e7ARJAJV5u1
	 N+d/lfcfJbd481nQlf2DkQlxe9KV4LS9pGve9omX3PTHglkwLvewF+7LIDmpuiTnd0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Phj9uxyuVQyQn0PWWMLPe+AXYqwew+XnkD6pbxB2yQ4=;
	b=YpfCsOO66/VDKNtnsWAL3vGuArJdpYOt46HhTWUyAZomRriw2wJ6tspokT32siOU/WtG
	 vDcvn9s3GLVZ3F5jRmdDjuQBpJUEPrVDjMyYZgFcJIWjHx2+JeoliInoxLjiuUelNFIBD
	 3AEmSfif8YhFAGSQngWuz7EVJAbdYt+ehlXYU2MYLFQzPRpVEWNdtgYDVVa4ETlE7CM2G
	 +ek5hzkjL5+UtCCL8DRrLIG8NJDbttAkM2/yNe76GrL4U3eSADMPxo9NwT1cuCfnvCU7g
	 Q198EkNXcNhzK408uqzaB1Z3HE/RiPTaFfGTDALp2KQU8UHlyteXjWMXoLoSLwhRiHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKauKXTI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB23F606A337;
	Wed, 18 Nov 2026 21:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKauKXTI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33EA1F000C4;
	Wed, 18 Nov 2026 21:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036760;
	bh=Phj9uxyuVQyQn0PWWMLPe+AXYqwew+XnkD6pbxB2yQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKauKXTI/8v6lyFdjjPLHzuwL713EHImdWQz3eL3UqVYjs+qVKVja1e/59IS5JB6j
	 f2ziSXbOPiw4o+Ag0Q3LNICeWNW6fdrmMr5MxtcrXBmvM3aRPZND7QK6f4VSeW66NJ
	 qD50r/Z2ClaZ8ujGErM+/z7AkCjw70qfz1I0Fp1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keita Morisaki <kmta1236@gmail.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1174/3318] drm/amd/display: Fix swap in median3() for DSC rate control
Date: Wed, 18 Nov 2026 15:29:56 +0100
Message-ID: <20261118150355.350132134@linuxfoundation.org>
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

From: Keita Morisaki <kmta1236@gmail.com>

[ Upstream commit 7b23bf82ccbdb4cf0752f2b8686e7319a7ce497f ]

median3() is meant to return the median of three values, but its last
compare-and-swap step swaps b and c instead of a and b. When c is
smaller than both a and b, it returns max(a, b) instead of min(a, b).
For example, median3(2, 3, 1) returns 3 instead of 2.

_do_calc_rc_params() always passes 0 as the first argument, and the
second argument is never below 12. So whenever the third argument is
negative, first_line_bpg_offset (and second_line_bpg_offset for 4:2:0)
is set to the second argument instead of 0.

Fix this by swapping a and b in the last step, as intended.

Note that this change does not affect valid DSC configurations. The
third argument is negative only when bits per pixel exceeds the
uncompressed rate of the colour format:

 - 3 * bpc for 4:4:4, 3 * bpc + 2 for RGB

 - 2 * bpc for 4:2:2

 - 1.5 * bpc for 4:2:0

Fixes: 97bda0322b8a ("drm/amd/display: Add DSC support for Navi (v2)")
Signed-off-by: Keita Morisaki <kmta1236@gmail.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1ddc4bc97a62fc89d9d3681413d9f977e1fa1a83)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c
index ef75eb7d5adc3..940de620e3308 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c
@@ -46,7 +46,7 @@ static int median3(int a, int b, int c)
 	if (b > c)
 		swap(b, c);
 	if (a > b)
-		swap(b, c);
+		swap(a, b);
 
 	return b;
 }
-- 
2.53.0



