Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAA710974
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAA8C433C0;
	Mon, 19 Jun 2023 10:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170888;
	bh=xM9bGE6k9cXHxFRbip/tz3yiUwwBm1pbywPPGFyUmWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDrnSr+l/v6iZWPftvOINkZmH8ggmZMd4Ktf11H0bPZimFOxBOHCMOq6cqe6nKr5e
	 L7Au0ppNyscNSckQ6jMm73hJlWMc4pakpzUeY8UqJbkMvHDivk7ShicfPEwCPbGD4t
	 ZozAdoHb98RBRdjw8BY3N9K4o6B7phpEptvaXrDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Lauss <manuel.lauss@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 035/187] MIPS: Restore Au1300 support
Date: Mon, 19 Jun 2023 12:27:33 +0200
Message-ID: <20230619102159.335357312@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manuel Lauss <manuel.lauss@gmail.com>

[ Upstream commit f2041708dee30a3425f680265c337acd28293782 ]

The Au1300, at least the one I have to test, uses the NetLogic vendor
ID, but commit 95b8a5e0111a ("MIPS: Remove NETLOGIC support") also
dropped Au1300 detection.  Restore Au1300 detection.

Tested on DB1300 with Au1380 chip.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/cpu-probe.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 7ddf07f255f32..6f5d825958778 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1502,6 +1502,10 @@ static inline void cpu_probe_alchemy(struct cpuinfo_mips *c, unsigned int cpu)
 			break;
 		}
 		break;
+	case PRID_IMP_NETLOGIC_AU13XX:
+		c->cputype = CPU_ALCHEMY;
+		__cpu_name[cpu] = "Au1300";
+		break;
 	}
 }
 
@@ -1861,6 +1865,7 @@ void cpu_probe(void)
 		cpu_probe_mips(c, cpu);
 		break;
 	case PRID_COMP_ALCHEMY:
+	case PRID_COMP_NETLOGIC:
 		cpu_probe_alchemy(c, cpu);
 		break;
 	case PRID_COMP_SIBYTE:
-- 
2.39.2



