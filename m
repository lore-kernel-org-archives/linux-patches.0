Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020519;
	b=a8y9RXfluGoxnH9DzGRbrg5UUbbWQyfwx4Yy3+Ev70NWWwD9e37BbIO0IHGOu6GeEeTI
	 S1fYbNEoOkPryiCesiug9U7iND67Dsq1d2oOg8R5ZpDiIUyqiDGJzLioc+w1kjMin3czC
	 fzgfpzNoF62CcAbSx3+PUIzMBfB0hfp9Ad90E+Dj5Trg6QHj9bxvg9LG0fUUrzbLQuwOT
	 Jcse0yigL8LRZFBlYkyXLQG7ODuOlzt5RUqKv83ZjdKlAqijHlLpQg/NL01gxbWFc40fh
	 gFiG4I1TAPTrAauRrXKihcskysZcrr3g/QQFSROek3BXhYYyRSFey6zKitYYbIGWuyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tVVsI3NEoWTYKvIo/VSahIIPX1AhAWBZRL88PBFdU5w=;
	b=tPNpMWDsIJpMR0NMZRHdQdA15vmL1lqza/qx75npvNkvk+UKJaX8eH7IJOlQVfe6vw26
	 LBuCt5nPBa+cRL0GibX/ywX+f1Lr2y2rgjIQZCLIyHx05nQlkQKgLurlGQooYpFxG5G4j
	 1s1rWwOMQIgFWaUBpGc2KlyWWm/KsywFYScLrPeau+wV1P6Ol9g0UVauZ9Xlr58C1tlqF
	 sY/itSUlUoxoXyZAsaMXRna/d2EMhel1g+qIToVbxb7mwSnKnL/S0gITnXPCxoe61M6cp
	 jIf+YFr1pl28cba5Df0uD10QTuLYoaXZESNIQiQT10qx7UpAgR86svD9AjvT2JjjUGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qlPKqkUo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A337606A31C;
	Wed, 18 Nov 2026 16:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qlPKqkUo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0811F000C4;
	Wed, 18 Nov 2026 16:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020519;
	bh=tVVsI3NEoWTYKvIo/VSahIIPX1AhAWBZRL88PBFdU5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlPKqkUo5a0DQmtdLxwpsFP1FU+t8NscG9loyq80gN30jojRPzLTau1Ssl4tUsfas
	 LF7qFuHfJzeV8pUVD5o6SxhyYm8OYmDpdyvCxNEGOPQopaD7+2u+krPflWwjL7IZzA
	 RWsiKbV7saVoeBRzfDjMgQTFHTIOZIfWeU7mpKcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1981/2651] ASoC: Intel: avs: Prevent module info underflow
Date: Wed, 18 Nov 2026 15:53:41 +0100
Message-ID: <20261118150357.730204163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index ea14ec1738552..f19a62e7e8b5a 100644
--- a/sound/soc/intel/avs/utils.c
+++ b/sound/soc/intel/avs/utils.c
@@ -116,9 +116,11 @@ avs_module_ida_alloc(struct avs_dev *adev, struct avs_mods_info *newinfo, bool p
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



