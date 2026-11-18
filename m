Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049222;
	b=a2tMmot7sx1oC7tNSEEpQCVMSvL+LZHSbY2sbAnpXiszmedoWiyWi3ccUUJ7eaU0UIyK
	 QY8gKHGwMVY9x5KeRkVe2VLx0d8IGGkcLZ6Dq4vUc0FV2PGngndIiPRtNmt+8cYn3CgAe
	 GgoANo+9lZ5Jodg8ZAIk1lkWgDUs8KIZ4Uigu821hbXiJfWqNbtld9KrTUAMCw/NcchCq
	 JopEC7GxTiJgAFcOHS1YVoDEQqRd92mJ9xk+GOJM2d+wlXeYkLLNYn4qcNUyjSmnqn15P
	 zcYrdS01SU26+kAlRrdJu5enAcFut7Swr0UWon8kFC2rIL67J9KXHuUXCEvQo+8t2hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fNPfjQWO/+ztkyPZGPVobxr0E0t3XCGXWo7k0Qs9X4E=;
	b=WKA15XCe6U/4KhnmxpRSlJMN93TSv+ZBL0N5/VhNkCO6ZbWsYFRGSdwOXNKeYloxedrz
	 tXk9l76SI/I7FczN1eW46IUFy4wvNepF+Bq180FZvFbPfsYI2Jvtsn7l1j2IuoHjGB2op
	 2u35QVIdUu9fKUPbpU3a43qjiUEuQkh/IBLEhQsft4NFJwmfhHrdjn8AAIJ5E8kOBjT5C
	 +srnZAInqLAtoBttZkIvGiTORS7Jx7gcvSguYywGQLH0MyqwJ9PcLJIXJSZ3DXLTURM7+
	 f6oExuXfbj3tdOn8ebssCyL9crCMddzqtTMFD0S+K0Vj3pJ5wAxl2Lv6T7BBI/hJo5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="C/08fISJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC6A606A320;
	Thu, 19 Nov 2026 00:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C/08fISJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CB81F000C4;
	Thu, 19 Nov 2026 00:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049222;
	bh=fNPfjQWO/+ztkyPZGPVobxr0E0t3XCGXWo7k0Qs9X4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C/08fISJ4WHIeidEa6ZOqAyTV3tECLn+NrbD1eEPJPVTyF1oSOPEcDVUVAweU23q0
	 LJlegcXXDLpwxj1dLmGwlBGFgXCOMMk6pEMh88G5CYUj5774Kg02EHrHEKPP1YkG93
	 qMsc1ukCeuKpjdCHv4koH9hJvOga3oGlNBFmaDUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2234/2857] cpufreq: sti: avoid NULL dereference in dev_err()
Date: Wed, 18 Nov 2026 15:54:28 +0100
Message-ID: <20261118150321.872248392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit fdbe4cae71c8196cd7681ad47254b5b0560d3c1e ]

ddata.cpu is NULL-checked, then immediately passed to dev_err().
Replace with pr_err() to avoid dereferencing NULL.

Fixes: ab0ea257fc58 ("cpufreq: st: Provide runtime initialised driver for ST's platforms")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/sti-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/sti-cpufreq.c b/drivers/cpufreq/sti-cpufreq.c
index 9c542e723a157..2ffdc193e594b 100644
--- a/drivers/cpufreq/sti-cpufreq.c
+++ b/drivers/cpufreq/sti-cpufreq.c
@@ -263,7 +263,7 @@ static int __init sti_cpufreq_init(void)
 
 	ddata.cpu = get_cpu_device(0);
 	if (!ddata.cpu) {
-		dev_err(ddata.cpu, "Failed to get device for CPU0\n");
+		pr_err("Failed to get device for CPU0\n");
 		goto skip_voltage_scaling;
 	}
 
@@ -281,7 +281,7 @@ static int __init sti_cpufreq_init(void)
 		goto register_cpufreq_dt;
 
 skip_voltage_scaling:
-	dev_err(ddata.cpu, "Not doing voltage scaling\n");
+	pr_err("Not doing voltage scaling\n");
 
 register_cpufreq_dt:
 	platform_device_register_simple("cpufreq-dt", -1, NULL, 0);
-- 
2.53.0



