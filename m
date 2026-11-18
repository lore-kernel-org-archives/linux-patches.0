Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018379;
	b=squXLBMEizSXWXxtw97N538iyjsU31JJbI1Czp4xnudUGJBR0Y3f0fDOjq7hIxMkwIOD
	 Bw1Lj1LX7bmxEoC6UStFG4woCrqbibCjbfAPJ/i8tZ/kSQQnGYIQfkIYCVrRxwYzfRlHr
	 klIZuSnjzw+WQfvF/tDviasn5RTfwCjfkiX0YoesRJpSj1TmVHy9QwQgKZWQihJSnefxx
	 7lvxStI/TZ8XVaWPNqENgIJA9GaOMsgdhwZM4bUoSnD5qgUWklr0o1nhJqcLUIgWZyk5u
	 usb3mkUHDmfAqTcBE5N3Anv307UhZxqhTNGzgc87cZ9UQngT64xZOD44YhpdKi7BpyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZnekZNsNvA+KLhmjtgkIX9sBEygWfVqa61iStON4KLY=;
	b=nM0ZWOa6oceDY822pmsrdQIwQEHDKCgfmYmlSbTtMFfiUTjrNrl8ocsZvqBaoyRWMLb2
	 bUJ3p3Xt9IHoFbUCqDbNuHU9wIsSX0PbJcJj8CXgvdGnW8MdoP//009segq3uDGBS48Dz
	 1sP4Z2JIGiOZ0p6DG+IlBu6s9xlyGovu+FspDW6pg30VoZ27o00dme3vdgq/wL8lsILtF
	 /BNEoVesk2lJzkSIf8C9grU+a8UcdO/a5yeFcF//nJgzibiogIPcqqHNANUBhYESFFaKY
	 UjQN/1+SWRmAPgUj7xkQLxhczo8aHDd2YdgiCAIGz8jHquwEVv/fr379pmLjV8kqpXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WUUtL2/c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D775606A320;
	Wed, 18 Nov 2026 16:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WUUtL2/c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3C31F000C4;
	Wed, 18 Nov 2026 16:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018379;
	bh=ZnekZNsNvA+KLhmjtgkIX9sBEygWfVqa61iStON4KLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUUtL2/cgKgF2sEWm+gB+9EhJSfMnHbg+XrBfJ/SkC8NOZztDKKCnruFF4jzVjyp8
	 WAjVw6gmUWHBWXF5PIpuneTFKhgSBhDjxaMKHkL++ZpyqOJJC/r5DPrn/w8iLhlJxz
	 y6em+7K8Sl+gKXgd+DzM7HlSusWLnNpEojotTXFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	James Morse <james.morse@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1179/2651] arm_mpam: Set mpam_feat_msmon_mbwu_31counter when there are bandwidth counters
Date: Wed, 18 Nov 2026 15:40:19 +0100
Message-ID: <20261118150330.455866789@linuxfoundation.org>
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

From: Ben Horgan <ben.horgan@arm.com>

[ Upstream commit b010d258f30a512a9eafaba6c50a0943f8420ab2 ]

When MPAMF_MSMON_IDR.MSMON_MBWU is 1, MSMON_MBWU is present and has a VALUE
field of 31 bits. If additionally, MPAMF_MBWUMON_IDR.HAS_LONG is 1, then
MSMON_MBWU_L is also present and has a VALUE field of 44 or 63 bits as
indicated by MPAMF_MBWUMON_IDR.LWD. Hence, if there are memory bandwidth
counters then there are always 31 bit counters irrespective of whether
there also long counters.

Set the 31 bit bandwidth counter feature bit whenever there are bandwidth
counters.

Fixes: fdc29a141d63 ("arm_mpam: Probe for long/lwd mbwu counters")
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_devices.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index dd422c56fbb14..403f302931817 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -930,9 +930,9 @@ static void mpam_ris_hw_probe(struct mpam_msc_ris *ris)
 						mpam_set_feature(mpam_feat_msmon_mbwu_63counter, props);
 					else
 						mpam_set_feature(mpam_feat_msmon_mbwu_44counter, props);
-				} else {
-					mpam_set_feature(mpam_feat_msmon_mbwu_31counter, props);
 				}
+
+				mpam_set_feature(mpam_feat_msmon_mbwu_31counter, props);
 			}
 		}
 	}
-- 
2.53.0



