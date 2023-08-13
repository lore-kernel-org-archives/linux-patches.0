Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C709446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F13BC433C7;
	Sun, 13 Aug 2023 21:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963235;
	bh=jgzM9WXS0g1aaipURMOQ982YuwBnso6nMbKe1YEzAgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpFOPx8SVLoNNa/cLdZ1dMtiU+TMIiusIsQZyuoy/tOJqKuzzms886p61eEQ2Odye
	 EJAfaWqAQzMC57AvHaH8iC+XU0frPy2ebCI47XMIYYZs/QbZKcoW378tUXjloPTffA
	 u1eUeoxex5mRlVQ0CkTnxMzAVnPkiV/nUz1rO+pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.4 13/39] x86/cpu/amd: Enable Zenbleed fix for AMD Custom APU 0405
Date: Sun, 13 Aug 2023 23:20:04 +0200
Message-ID: <20230813211705.286580541@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211704.796906808@linuxfoundation.org>
References: <20230813211704.796906808@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

commit 6dbef74aeb090d6bee7d64ef3fa82ae6fa53f271 upstream.

Commit

  522b1d69219d ("x86/cpu/amd: Add a Zenbleed fix")

provided a fix for the Zen2 VZEROUPPER data corruption bug affecting
a range of CPU models, but the AMD Custom APU 0405 found on SteamDeck
was not listed, although it is clearly affected by the vulnerability.

Add this CPU variant to the Zenbleed erratum list, in order to
unconditionally enable the fallback fix until a proper microcode update
is available.

Fixes: 522b1d69219d ("x86/cpu/amd: Add a Zenbleed fix")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230811203705.1699914-1-cristian.ciocaltea@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -72,6 +72,7 @@ static const int amd_erratum_1054[] =
 static const int amd_zenbleed[] =
 	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x17, 0x30, 0x0, 0x4f, 0xf),
 			   AMD_MODEL_RANGE(0x17, 0x60, 0x0, 0x7f, 0xf),
+			   AMD_MODEL_RANGE(0x17, 0x90, 0x0, 0x91, 0xf),
 			   AMD_MODEL_RANGE(0x17, 0xa0, 0x0, 0xaf, 0xf));
 
 static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)


