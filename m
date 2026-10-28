Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213696;
	b=yarzkTus8zUhJOm1cFt2zRA6uzHJbhTK4CjQXFSitrLfLn5SAqeLCdsZlJvG1kMv9QG4
	 atIlMyyBIzvfjN4mAAp/9Qz4UQ0Zzj0cCviQCfE7BB9ovqVZVDTQwwQG7hVOIAqXQr6Wo
	 4OujrPBWe9OnoPYdgtHp5JEY7nnEsQSKBNS9p60OuRCO6lCqpfxjy/ePUuWX4ArHqYWIz
	 TUHlhw3izBhij7j+/VMThqAdWG7e7mBxPy2F1rlS9GC30WPWqN/L7YUKrk1W6qB0ECx8k
	 pdEeyPqwqa6JD3FwYUx28KNkQQMUxXzWsxwGE97nhs/UTFTll5KD87rPKnV79B6cMAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JxIIZ9CGwjhvzkgbuiaq7MH8b/ZsCx1WzjKnVDhH8Hg=;
	b=mqFfoKfge0KFDyWsEssgMJrLB3COiXcWcAQYt2W1TMZo09GlTFShtGXIy9f5X4CcGSmu
	 oVovhwpN+SWBsEXO039sHjw6u4/gdEk837Jl4RgEQ0TYB6LcSb+FDNIGOqE+HlXOrzBlo
	 YLQYG6BxQYsVMgLyWdCeb6w4hFLVmeRQdB1MlpP/7GSc3WBOEb3/VR4qFdDZFjI39AYCG
	 uOkbvs9WMGhj41oZ56pqg/xtoFFdWK/7PKj2YGaEHGGL6yMyJutWL6s4YtAMB8vqLnal2
	 7K1W226mROyTCQ843+OiNbHHf/tnhA1bPO33zqXlLoQrLSZqgx9ekP9gdpRxSdY+aew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="z+hfcP/H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740AE606A31C;
	Wed, 28 Oct 2026 18:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+hfcP/H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCAA01F01825;
	Wed, 28 Oct 2026 18:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213696;
	bh=JxIIZ9CGwjhvzkgbuiaq7MH8b/ZsCx1WzjKnVDhH8Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+hfcP/HhhVCaHh8iSwEwkqZpacpQOV8xrs3PIKAZ/pZB7EjWIuA/lOUFt3JSQD+x
	 N8IQogiDSzsCOg+GM0t2eyjnhfDIpGO/70y0r7u7tkhhBxlBYvIYCwEbRadOL1IiNI
	 mBl2V6OhZPw5FGb+9UKhFuU3Kp6AVxTPT4RZhX90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Allen Pan <allen.pan@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0597/1887] drm/amd/display: Add a dc_state NULL check in dc_state_release
Date: Wed, 28 Oct 2026 17:44:53 +0100
Message-ID: <20261028170513.003374327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allen Pan <allen.pan@amd.com>

[ Upstream commit 334b56cea5d9df5989be6cf1a5898114fa70ad98 ]

[How]
Check wheather state is NULL before releasing it.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Allen Pan <allen.pan@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 6a415e2e6b8ee..7594aaf79a101 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2283,7 +2283,8 @@ static void dc_state_free(struct kref *kref)
 
 void dc_release_state(struct dc_state *context)
 {
-	kref_put(&context->refcount, dc_state_free);
+	if (context != NULL)
+		kref_put(&context->refcount, dc_state_free);
 }
 
 bool dc_set_generic_gpio_for_stereo(bool enable,
-- 
2.53.0



