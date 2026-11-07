Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063606;
	b=ntXlJ0o5zkzwj/0uXYHFoYnvPgA6nzXb6kf/Ny9dANNNZu3Lmt88qUp3OlI2UmzM3Y6n
	 tqFBl2c4NvGxl9INi7VRYiU84J5t7Wmf9rZt6TGHTtRk/5DTOliIteFLi/niXeSjGZeUu
	 GdIhTIX91B7FZeq9x0oeBd6exwqmMrfEtfBfn2RYKrrvax/RC+ctcZT5IBzugU92PqgPM
	 KJCRbN8umr9pLCBGwtPFvSAKqrs1Sf7xw5Lu9A6spagdRj/ABNd28EaWOCp3NEDCLLrbB
	 JVMBFZJ5fkm1SEPcY/r9DkFKG1DRzKMj+uYDU+DCMRINy1h3uuIPqbC8SoTHE+6ITTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Uvqt9sp0au17drKOtRxT3JIG1BWrof/7hxG6+icL79g=;
	b=lP7k1zKZWWOCGnSaXvrUZBM8lFY0IhswL+aNxlYhxv+5vivvpRecM63memulU6kAo29m
	 F28ONwYgGRWNXqNNOczxWbjW5hRQTKvg8LRN6tyGFDHTiU/l0R3zw7ZpKR3rdH2iepQWe
	 wjId5LmJYmY91oVa1T8cxfXuHkt5PnSQJXv0ScTMYSpXg/Ljdg+x8Huj8oMKxCeBf4XOG
	 gsDPpJthgfmyX41vIWJqsmixlRGn0/SC2YfjArgx0xLepNQXbZ/jPL0e5kMUFm/cTTuPX
	 ICc7bUY9htjU4D/GOEe+pxKMj4miAiXZ3vPL71i83FEFDmf7vbonxetMJ29RhDaGqfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=01cBERk3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E87606EE81;
	Sat,  7 Nov 2026 15:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=01cBERk3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7025D1F0089F;
	Sat,  7 Nov 2026 15:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063605;
	bh=Uvqt9sp0au17drKOtRxT3JIG1BWrof/7hxG6+icL79g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=01cBERk3iUDlpcL2d9TQ+zXO/oTV5MUFRjwa40v/8ssexoS32ovvInqssMNuxHvOq
	 r7W+Hz+8lFpSw8ceLP8SWxFWOCpcNx1hGFuXACAwZWNvCDoRNEzhq1mHNJ0uD59xbW
	 NNpXWAOo9ZRFDeEW7rZgE4t1nUR8QAWV5VrhmanU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keita Morisaki <kmta1236@gmail.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 680/869] drm/amd/display: Fix swap in median3() for DSC rate control
Date: Sat,  7 Nov 2026 08:56:02 -0500
Message-ID: <20261107134916.125249100@linuxfoundation.org>
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



