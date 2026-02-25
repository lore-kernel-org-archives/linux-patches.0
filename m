Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6228A2690EC;
	Wed, 25 Feb 2026 01:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983689; cv=none; b=gBtxQQktQfjh4sGL0QvNTZfmnrljxgB7DhdNfTf19IQhAXooLYNiMgOXN4WubyYhHz2KnesSSBOKKDGZQMSmAR4DK6dChN2KKc0gQxlruz0JkbMLDyWzTOCmZtACXnxycu2luWms8iVv7/p4EjgZYECepHPrIGJHfmFhCREMpmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983689; c=relaxed/simple;
	bh=oTlZXuYVf91GUgB56nTHMbgIuYh1wMHDB1BZdL0CBKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wns5FsqCQ4J+sRtqdqca3BSZuIYdeGLULsa7eqDSUbbBUjbuRz6PJumqA2fhNLVU3TEuMrkAzVeYGIl0ZzvfidysfDz1k/+5kj1eX0UlPdfSdi7A4dreXui9eB+6lYSxAxgFh9bBMQIXosqegpI36zspC3W1QbLdlS7U/rj2uWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npy+Kkrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npy+Kkrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22891C116D0;
	Wed, 25 Feb 2026 01:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983689;
	bh=oTlZXuYVf91GUgB56nTHMbgIuYh1wMHDB1BZdL0CBKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npy+KkrkFD7QISwlNHpoHdbHQyqzfzo02ayZYEv8r0ztVl7D1DXQJTBe29FE+8EW9
	 KXh8a5LKQ9FAAmtnPSt09LGvSlTwBa9bbVKpVnfe98NzsYKqHpsc/QMxVga1vIrOXY
	 9NSQJZmVQFTf2N357MG0r/491/h+xYBbJBof2YDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mauro Rossi <issor.oruam@gmail.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 745/781] drm/amd/display: Dont call find_analog_engine() twice
Date: Tue, 24 Feb 2026 17:24:14 -0800
Message-ID: <20260225012417.998103191@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 613b1737abe1bd0a65b49851e777231302095e28 ]

The analog engine is already there in the link_analog_engine
variable and assigned to enc_init_data.analog_engine already.

I suspect this was a rebase mistake.

Fixes: 436d0d22aa70 ("drm/amd/display: Pass proper DAC encoder ID to VBIOS")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Tested-by: Mauro Rossi <issor.oruam@gmail.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_factory.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_factory.c b/drivers/gpu/drm/amd/display/dc/link/link_factory.c
index d9cb6b6714009..9003e0d314e00 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_factory.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_factory.c
@@ -648,7 +648,6 @@ static bool construct_phy(struct dc_link *link,
 	enc_init_data.channel = get_ddc_line(link);
 	enc_init_data.hpd_source = get_hpd_line(link);
 	enc_init_data.transmitter = transmitter_from_encoder;
-	enc_init_data.analog_engine = find_analog_engine(link, &enc_init_data.analog_encoder);
 	enc_init_data.encoder = link_encoder;
 	enc_init_data.analog_engine = link_analog_engine;
 
-- 
2.51.0



