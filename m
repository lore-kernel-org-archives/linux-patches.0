Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017689;
	b=3V/5agGtRrONHLcP7SNu/XZVkCPsK/EsvaFJ2xYMgnWTzP4pw3iDfynHPUutVTHffKDV
	 tUaFKFNSb+9mvYeg/klDz1D5TP3NIXVaxBD1GlBCpN0pqopOwN4RgbKdyiycYXfog9oBy
	 KIarj5uImdvsaKpYvHhW3sIZU0fmDnEfw/Y/gjGKIU0/z8z7odWXhAwoa62p89KIBtPdm
	 mKNMSry4GHUkmAhRiaZNV4X2cYSbCDJvWNIR9m1Pij4tfGUgqcvMLvEiNPVLpNKtRzPLZ
	 MVomwamF0pKbomeDsiWcNjg8Cnl2eW/0P/sMFLms8ouXABH1Npd4u5OoGGpwXlM58pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bcnhcH2BKE0Sw9qZ2tnWjy/yrrVgMHMplKYj1002CEk=;
	b=GY5WVamXypjC8P8VMU4ToJ1QuPOa18ZLsbCBGDovJ9fFkP+6WgnVCG2vj8bDlyuL301W
	 l8su/1w6mVT2dbZCqrfOCS9CW6JHrC6PZfYrrrIP6sJY2Sshpx+Ocj+vD1QSxQtSoPohe
	 BEVWl8H5vYewcSglmf44EuPL9xpHNk0I0Hlam+qgP9hneC/YzwzZhBwxaqLEeAEklORyq
	 zOwwVWwmzXpScfkiSEviC6UiHm3vdCZ0Cm9GY9H3m5zkgJi9/kITMo5VGgdSzqi6E2bPi
	 t/tkZcDEGo9wPGkokwyTgRh3wS5NvZ50uOtSGwDCSKG4PlIKNjlWEuD72tAVtA6qBNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UHwLAb1R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55054606A325;
	Wed, 18 Nov 2026 16:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UHwLAb1R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937421F000C4;
	Wed, 18 Nov 2026 16:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017689;
	bh=bcnhcH2BKE0Sw9qZ2tnWjy/yrrVgMHMplKYj1002CEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHwLAb1RgA76xpt5Rk4ACNeHfwNcKBrw4DSfZh31IV9S5PeWlUmuUh+50DyxmqDRe
	 Q9eY4k3JaRRC6aioAWO9iEEgXuQRdaDvVp1h7bnyeH38LNo77DUYF+nvEohnNAkYPJ
	 vJwuxhRSY8GKmbFgwh16rpXKoIl0W9bzfr/bn/YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Kondratiev <vladimir.kondratiev@mobileye.com>,
	James Clark <james.clark@linaro.org>,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@bootlin.com>,
	Ian Rogers <irogers@google.com>,
	Markus Mayer <mmayer@broadcom.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0974/2651] perf build: Improve fix for "argument list too long" error
Date: Wed, 18 Nov 2026 15:36:54 +0100
Message-ID: <20261118150322.965953906@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Monin <benoit.monin@bootlin.com>

[ Upstream commit ea2058a975c549bc2cae3ae42490c3f5a846ad81 ]

The orphaned pmu-events JSON files are passed to the shell via
`echo "$^"`, which puts the whole list into a single argument. With
a long enough output directory path and enough files, exec'ing
/bin/sh fails with:

  make[5]: /bin/sh: Argument list too long
  make[5]: *** [pmu-events/Build:228: prune_orphans] Error 127

This only happens with out-of-tree builds, when setting O= to a
relatively long path.

To reproduce, build once with JEVENTS_ARCH=all, then rebuild with
a smaller JEVENTS_ARCH without cleaning first, so the leftover files
become orphans. Using nds32 (which leaves ~1100 orphans), an output
path of only ~70 characters is already enough to trigger it:

  OUT=/any/long/path (at least 70 characters)
  make -C tools/perf JEVENTS_ARCH=all   O=$OUT -j$(nproc)
  make -C tools/perf JEVENTS_ARCH=nds32 O=$OUT -j$(nproc)

Express the orphan file list as paths relative to $(OUT_DIR) by
stripping the common prefix and restoring it with printf, the same
approach used in scripts/Makefile.clean, so the shell arguments stay
short.

Fixes: b6712d91f8f5a289 ("perf build: Prevent "argument list too long" error")
Suggested-by: Vladimir Kondratiev <vladimir.kondratiev@mobileye.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Benoît Monin <benoit.monin@bootlin.com>
Tested-by: Vladimir Kondratiev <vladimir.kondratiev@mobileye.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Markus Mayer <mmayer@broadcom.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/Build | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/pmu-events/Build b/tools/perf/pmu-events/Build
index 372773b998e40..4c7b082cb2bbb 100644
--- a/tools/perf/pmu-events/Build
+++ b/tools/perf/pmu-events/Build
@@ -223,9 +223,11 @@ ifneq ($(strip $(ORPHAN_FILES)),)
 # of a build step.
 quiet_cmd_rm = RM      ...$(words $^) orphan file(s)...
 
-# The list of files can be long. Use xargs to prevent issues.
+# The list of files can be long. Remove the $(OUT_DIR)/ prefix, and
+# restore it with printf, to prevent "Argument list too long"
+# (see scripts/Makefile.clean).
 prune_orphans: $(ORPHAN_FILES)
-	$(Q)$(call echo-cmd,rm)echo "$^" | xargs rm -f
+	$(Q)$(call echo-cmd,rm)printf '$(OUT_DIR)/%s ' $(patsubst $(OUT_DIR)/%,%,$(ORPHAN_FILES)) | xargs rm -f
 
 JEVENTS_DEPS += prune_orphans
 endif
-- 
2.53.0



