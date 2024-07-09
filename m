Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6152627713;
	Tue,  9 Jul 2024 11:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524483; cv=none; b=qIhGq1bzNU6RKrl/1oJmRkX2MxyJhMjVIUqsacc1quHwxz/ex1BolLHnpL95giWdGyCTjA2bjLe5d9/kZJhAZEZXQnuJBpaPdU9cvJiqxAmn52rmc1L2u8Xs6dqGxUYUf5FQeq1uatgMq2+C7wnUYyt1mylctLfV/2zJZq8a0dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524483; c=relaxed/simple;
	bh=huiE9Otl7kiGmnGs2/fieiVAI67bX8hzvS1TMxw71fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QnsObBW4Ergd81JkVU7n5rVumMAoEgPZWqjZPinrvUGiHmVIKGYQ5s3hsXuvT5DKhf1GXRjklOSy+00jiUyF/DQ8cw8XMXPhd6wcL/OFHdDfpBesx4d+0KH2zQymYB1LlFy1pUvj56EH+yi/tsAjCCe4WFzbvYUcZAOARAv44vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGIW8Dxy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGIW8Dxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F30C3277B;
	Tue,  9 Jul 2024 11:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524482;
	bh=huiE9Otl7kiGmnGs2/fieiVAI67bX8hzvS1TMxw71fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGIW8DxySZZx5s87EWgBJEEGz6p/0V+NGya4y5683xgq7ALy1XViNq0gWBkEca0AF
	 4Ksh8wFfzc5qHCtki1gm0bNRYyrgaThqpylpeB7do1oqLzlNwIh1w/5eYhFSli53yU
	 T1uEwGKrIe9lYGjbKzFp2l2rwLYoFAXxvfbJg1e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 194/197] drm/amdgpu: silence UBSAN warning
Date: Tue,  9 Jul 2024 13:10:48 +0200
Message-ID: <20240709110716.448019163@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 05d9e24ddb15160164ba6e917a88c00907dc2434 ]

Convert a variable sized array from [1] to [].

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/include/atomfirmware.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/include/atomfirmware.h b/drivers/gpu/drm/amd/include/atomfirmware.h
index a34f064df336b..09cbc3afd6d89 100644
--- a/drivers/gpu/drm/amd/include/atomfirmware.h
+++ b/drivers/gpu/drm/amd/include/atomfirmware.h
@@ -3583,7 +3583,7 @@ struct atom_gpio_voltage_object_v4
    uint8_t  phase_delay_us;                      // phase delay in unit of micro second
    uint8_t  reserved;   
    uint32_t gpio_mask_val;                         // GPIO Mask value
-   struct atom_voltage_gpio_map_lut voltage_gpio_lut[1];
+   struct atom_voltage_gpio_map_lut voltage_gpio_lut[] __counted_by(gpio_entry_num);
 };
 
 struct  atom_svid2_voltage_object_v4
-- 
2.43.0



