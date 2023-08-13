Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3059E9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC07BC433C7;
	Sun, 13 Aug 2023 21:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961731;
	bh=qsHgEYVouqE3pdEQch4uG/q2gcelSJw+AloOGh5OV6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpwrbWJ5wRnsGviFIRMQNwqFhobyBCAAPrT8yoaKLytjopkmDSjWtrHkY0jEilyFO
	 aAVg1bHTufvHA8Ef6TOT7QATp0rwjB05ZU+RWFqwPde1wUuSnjncf85oDBYee1cZeb
	 9hKy9n3yUc0sgM/8OkgPjOVXpvt8vJvheTe+fWtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 4.19 12/33] x86/cpu/amd: Enable Zenbleed fix for AMD Custom APU 0405
Date: Sun, 13 Aug 2023 23:19:06 +0200
Message-ID: <20230813211704.369473541@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211703.915807095@linuxfoundation.org>
References: <20230813211703.915807095@linuxfoundation.org>
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
@@ -69,6 +69,7 @@ static const int amd_erratum_1054[] =
 static const int amd_zenbleed[] =
 	AMD_LEGACY_ERRATUM(AMD_MODEL_RANGE(0x17, 0x30, 0x0, 0x4f, 0xf),
 			   AMD_MODEL_RANGE(0x17, 0x60, 0x0, 0x7f, 0xf),
+			   AMD_MODEL_RANGE(0x17, 0x90, 0x0, 0x91, 0xf),
 			   AMD_MODEL_RANGE(0x17, 0xa0, 0x0, 0xaf, 0xf));
 
 static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)


