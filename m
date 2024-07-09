Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB1F55E4C;
	Tue,  9 Jul 2024 11:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523877; cv=none; b=EHB86jTsb9ISGd9dPqLHQakGumWbbBtq57S2zBXsQOwwfhfcx4PWdpAhE2IP490+ZfJmUea61gmpOEI/Flfs29FhE60oPnTa4FEWraMqGw4mWvYYtaKrm/p0g1482EflXY9L9lIhgCPmRfJTL36w6h6xhHE9JHRjcD7nfoNX1Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523877; c=relaxed/simple;
	bh=Qf0oKVCfdxlkkLnm3/OoVbNzEZVXvBeEDLMRTzp2G40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KPcHjeUjw6iaxB+hB7y+H3G0f0QQYpLV60mp1klAAp0X3fqQpxwfJPFS292NghHGynsNnE0TQfTdCSRTTbnjJlMz0fQpujONrM3Sr2YBNTC+WYnF0gMWBjR1mz3yqMwdwMsu5ouwNP7oAHK1YbHaL3vikdpQRFU0DKwL+axUprc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsfj1o2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsfj1o2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D8BC3277B;
	Tue,  9 Jul 2024 11:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523877;
	bh=Qf0oKVCfdxlkkLnm3/OoVbNzEZVXvBeEDLMRTzp2G40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsfj1o2sklDTxAwLXBbwaJCmZDMqQW5yrD/Qd2c5Wt5H27LmivXa1dZSS8Pjaeg4h
	 gb6qL6dA7QkKDF1EUbGer7nMviBT1U4VXYBUM/bAEXRAEErGA6sXSVx+1czh6lwDI3
	 0oxGdCOl8T0zEfm6uG0u9Ko8aWWPXSQqiME4EJrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/139] drm/amdgpu: silence UBSAN warning
Date: Tue,  9 Jul 2024 13:10:37 +0200
Message-ID: <20240709110703.461918976@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5848617252317..6c8b4afa7cc6e 100644
--- a/drivers/gpu/drm/amd/include/atomfirmware.h
+++ b/drivers/gpu/drm/amd/include/atomfirmware.h
@@ -3551,7 +3551,7 @@ struct atom_gpio_voltage_object_v4
    uint8_t  phase_delay_us;                      // phase delay in unit of micro second
    uint8_t  reserved;   
    uint32_t gpio_mask_val;                         // GPIO Mask value
-   struct atom_voltage_gpio_map_lut voltage_gpio_lut[1];
+   struct atom_voltage_gpio_map_lut voltage_gpio_lut[] __counted_by(gpio_entry_num);
 };
 
 struct  atom_svid2_voltage_object_v4
-- 
2.43.0



