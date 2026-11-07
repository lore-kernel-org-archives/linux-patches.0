Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064271;
	b=pMUwzT0mmNZMNcItwsAzDLQd4I5/x42LESjoiLCfDeYqA9YejOb5W2TJ3XAEGP8oHCTO
	 hc0/bIHjSwFFyYsxicDYkUyujxaIEb1Fm0obhEXh1QFg6UJWZ18qxs/p+seQDQ1BvZbHh
	 LjTCZOxm9wccWyFxnMLBkQUDvh6Qvj3VGDIiL2AyUFomliw1Bc6ItY4CuuxZZ1c58elaH
	 kXQ33s+pwTUexy3zZKRn8uQWTVhEcpEEea0izTxQeSGcF7IZ9eGGPQaYD9szIxaX8ZPQP
	 gsK73/U24SPdXB92TW47bOSG1UT9gDtmfPXz1mpyT4NwHm9pmsZ/+G4f6UsIdhTOTGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=btir5oXnrlLUFoA4QqkGur1qkpGh5tFZ1OHCA5teaaA=;
	b=yaVVrHgTHAsaoNhY85vZWNQOOB6i92U+e4eT7dNpx6h63W7pTMqF50k4V3u1Z12G3h3u
	 JPDim6OVikLFCr9r5oOCllvjN+D5VSgxaP+AzAqh/3cRB086HJgcclAJvTLOrm1QM40oG
	 ZHegGsakefchCKsnzUeZcALRbIAD8uqbpPeg1GZmge03fAQoC5x1UgoMjtKO49O+APIJi
	 bK2FIC6F3aWbSbGfwtPHhlW3P4GAdXh6n9VoP4BhU4Kx5tM4NYXSovi+qE0j5ty3fNNlA
	 lm0FSCIXDb8EofLPL9lFpbqjgVa8gRwdWfdDc6ibWNd5cCs97frfPQShNHxxzjTdo6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Az1IPGAL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B075606A334;
	Sat,  7 Nov 2026 15:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Az1IPGAL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FEB1F008A1;
	Sat,  7 Nov 2026 15:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064271;
	bh=btir5oXnrlLUFoA4QqkGur1qkpGh5tFZ1OHCA5teaaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Az1IPGALUE91fq5ENtt8ObC77jhIyo/PsQyqctMZDdUrouij5yyjkWlyMqIXOOKOc
	 WjU7rZckVy2Ddxv5YjkCUlKc1KXyjazhtBhAvR9JVuGWonQFMNsV7WIXgJjoa2kkpQ
	 0kx/jJ4SCD+VPtavYRkokVaDI+S/RkeQH3+fdDug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0368/1257] media: iris: Fix frame interval enumeration for non-divisor framerates
Date: Sat,  7 Nov 2026 08:44:24 -0500
Message-ID: <20261107134949.732856431@linuxfoundation.org>
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

From: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>

[ Upstream commit 3ad393b701dd99274f09403185f71ec7a93135bd ]

iris_enum_frameintervals() advertised frame intervals using
V4L2_FRMIVAL_TYPE_STEPWISE with step=1/MAXIMUM_FPS where MAXIMUM_FPS
is 480. This caused client to enumerate only framerates of the form
MAXIMUM_FPS/n (where n is a positive integer), restricting support to
exact divisors of MAXIMUM_FPS (e.g., 480, 240, 160, 120, 96, 80, 60,
30, 24, 1).

Framerates that are not exact divisors of MAXIMUM_FPS, such as 29 fps,
25 fps, were excluded from the enumerated list. There is no hardware
restriction to framerates that are exact divisors of MAXIMUM_FPS. This
caused GStreamer caps negotiation to fail with an "internal data
stream error" when encoding content at such framerates.

Fix this by using V4L2_FRMIVAL_TYPE_CONTINUOUS. With CONTINUOUS type,
GStreamer creates a continuous framerate range [1, max_fps], allowing
any integer framerate within the range to pass caps negotiation. The
step field is set to 1/1 as required by the V4L2 specification for
continuous frame intervals.

Fixes: a6882431a138 ("media: iris: Add support for ENUM_FRAMESIZES/FRAMEINTERVALS for encoder")
Cc: stable@vger.kernel.org
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_vidc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vidc.c b/drivers/media/platform/qcom/iris/iris_vidc.c
index d39ac71a25aa6..f1d7f186002d9 100644
--- a/drivers/media/platform/qcom/iris/iris_vidc.c
+++ b/drivers/media/platform/qcom/iris/iris_vidc.c
@@ -438,14 +438,14 @@ static int iris_enum_frameintervals(struct file *filp, void *fh,
 	mbpf = NUM_MBS_PER_FRAME(fival->height, fival->width);
 	fps = DIV_ROUND_UP(core->iris_platform_data->max_core_mbps, mbpf);
 
-	fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
+	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
 	fival->stepwise.min.numerator = 1;
 	fival->stepwise.min.denominator =
 			min_t(u32, fps, MAXIMUM_FPS);
 	fival->stepwise.max.numerator = 1;
 	fival->stepwise.max.denominator = 1;
 	fival->stepwise.step.numerator = 1;
-	fival->stepwise.step.denominator = MAXIMUM_FPS;
+	fival->stepwise.step.denominator = 1;
 
 	return 0;
 }
-- 
2.53.0



