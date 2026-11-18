Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049955;
	b=eXCmu8ULsfIGflKRqbWBrskxNjq6ktZQ4dGHkaSxTTsSHJoOxXrN6d1CGF/8ANeH8Uyf
	 HUqrI5CbC9JxCXR9ltxUjV3Qa7tXCkHLFuoosSGtkzkv9tWjdIpEOCrRjrwCL8hQEnAzA
	 vl2fgCnbSyWVZSe+/nQUEu8PEIP3FxigYmFuQOSkVSwxxXqclYXlam8tRoU/8m5bww1oE
	 Y/rY06zVKHalOGL+KFjjPRSzeLMuA9HWEH1JMMjqILMlUDZTswI0z43pynNqdeZassweA
	 1gqMzop9agl0cBtAgUjU2IoNhXcX/124Mkgt0m02gfk9gjFknSX9gXXzCCDY/u9oGNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N5wplrZB72H1hJtls/KrqEU8AKq6/5DZ0Obl0RYcWfw=;
	b=TyTVqwbcWcG9eV21hfb7aFsV3Tgi56XrQGBZKqvVi7rU8KmzSJHOuhHM3nomLFWLXOQB
	 qcTOFjZo6NlUHnTIgBpQcUHB8ADEVwFknp2Ze5SeDQnfoFuYMohH1kIMQRifiEWq8masl
	 D5bGJG4f4w1S/3gtpv+f+NiMdUAGY5jCJ+HA8p2sSxUD4T0FhCzB9GH5b/VFqyo8/fhl3
	 Dm83suZ4WNGM2lHTM7CnEZVuuifaS3q6s0DUjl6m5JWbQpb2qi3ach5nL+W1+ehooo3VM
	 htn/6vXHbA/ZM+ELoruisUdxId3B0PYRRGG0DEDngi0CDpCF8/i/Q0u4TLIdOhcYE5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhYPgFO0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8A3606A31C;
	Thu, 19 Nov 2026 00:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhYPgFO0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7713A1F000C4;
	Thu, 19 Nov 2026 00:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049955;
	bh=N5wplrZB72H1hJtls/KrqEU8AKq6/5DZ0Obl0RYcWfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mhYPgFO0O5ACD6w4YOjJCJQ8zZuInhCfXxgh8rWQ2MP4EV7AvkjqZNEmo4tyPeIcj
	 nL2KO0srdc8koMxCiFc6qqzeczR0pJBXlTzg2YndFucAi3kKBOw/YIw/48eihrzGAR
	 +FVnsT/tVtDCVPclB1wWvp6PFnCu8T/2FJHYQg1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2534/2857] ASoC: Intel: avs: Prevent module info underflow
Date: Wed, 18 Nov 2026 15:59:28 +0100
Message-ID: <20261118150332.770451626@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 05c2975b4267246219e7aead0467626107e204e9 ]

Typically modules information is first initialized when loading the base
AudioDSP base firmware and then expanded when loadable DSP modules are
requested by platform-components, see avs_component_load_libraries().

While theoretically not possible in a production scenario, there is no
reason to continue the IDAs preparation if an event caused the newly
obtained module information to be smaller or equal than the existing
information.

Fixes: c1a427e8da93 ("ASoC: Intel: avs: Firmware resources management utilities")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261015190240.729793-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/utils.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/avs/utils.c b/sound/soc/intel/avs/utils.c
index 13611dee97877..ee0149135dc41 100644
--- a/sound/soc/intel/avs/utils.c
+++ b/sound/soc/intel/avs/utils.c
@@ -118,9 +118,11 @@ avs_module_ida_alloc(struct avs_dev *adev, struct avs_mods_info *newinfo, bool p
 	int i;
 
 	if (!purge && oldinfo) {
-		if (oldinfo->count >= newinfo->count)
-			dev_warn(adev->dev, "refreshing %d modules info with %d\n",
+		if (oldinfo->count >= newinfo->count) {
+			dev_warn(adev->dev, "modules info underflow, old: %d, new: %d\n",
 				 oldinfo->count, newinfo->count);
+			return -EPROTO;
+		}
 		tocopy_count = oldinfo->count;
 	}
 
-- 
2.53.0



