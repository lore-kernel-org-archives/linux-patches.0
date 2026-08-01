Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A22E2931C7;
	Sat,  1 Aug 2026 14:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785594024; cv=none; b=d6wGgLWzUEkavusTuP8dZpxSM967O+qBFR+QE1XFUpN4jq0k8R0Tv8vtUCI9adE3NEFskrlMUUkvPvqb/ysDkMJKqTG+BFseMX4AxArYwQAcM6+U3cCFjISUN15iaQpZLqimynVijb4WF/VJJoMsTiCbqhbM5idBkQ9CjTna+ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785594024; c=relaxed/simple;
	bh=nSt60UJtWVxLsGKbgw1HcToN0dR/IHEcak2s3lbloZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwccAQZbeYC5rcSp12jgLc7jXFJkHIv97QZbQ1fJYlfvEGe09OAZ9qUDN3sUYK0+FnIZN4nUXlhuGs3qUa4hDapOPdNL+sDmYSLnP9MrdZwpWaJPWA0oL49U/ZAytZUmrxykYpiKshoZ5HdXCj0Gdn/xYR/AHipUnpi6GbR4QD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eRiWx9wb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eRiWx9wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D7C1F00ADB;
	Sat,  1 Aug 2026 14:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785594023;
	bh=DXkV0v3KhWSQY39L4P+V9ZY08u22dL9CRa7qm8XpPkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eRiWx9wbtGt/blU+6SVRhNivrum3y+fsAtddIcJMW95juO9xokzIHLdbQZ3u6le2Z
	 Z5nfRk0wGhPFFZ+JV+kQJnjVLR5Qkoi51T6WO2DRyamhfscmLjecp+gm3iMGwpJV8t
	 x3OfKqcF5G0tOkoQEyX8KaEFpyoYhg5vhmX4jj13UvjIybkUWdMTs/MbNUq9ElnDL4
	 zzK8swkI8i79/HlWFAv7PjxyJsDRtmwEQavOI6ezeUjxGF0N1X4tpBdYS9AabIlSVe
	 V60yRM0E2wdNRcRERHq0MvooniutnEq8gM36wkPhdePws9zb1Uyb72+maNaZUwQE2E
	 +KXOKsSsCQcEA==
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	vegard.nossum@oracle.com,
	Krzysztof Kozlowski <krzk+dt@kernel.org>
Subject: Re: [PATCH 6.12 0139/1276] arm64: dts: qcom: sc7180: Add power-domain and iface clk for ice node
Date: Sat,  1 Aug 2026 10:20:17 -0400
Message-ID: <20260801101505-6a6d5089afcf@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ab3c3006-bfa0-417b-86f7-95470c73e547@oss.qualcomm.com>
References: <20260721152446.065700225@linuxfoundation.org> <20260721152449.211750681@linuxfoundation.org> <a0273f34-8596-4b6c-a489-66a4533b6dd1@oracle.com> <ab3c3006-bfa0-417b-86f7-95470c73e547@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Jul 31, 2026 at 12:51:25PM +0530, Harshal Dev wrote:
>The 1st can be taken on-top of the four DTS, since describing the clocks
>first but enabling them later via the commit is totally fine.

Thanks for confirming - and no worries about the delay, enjoy the
vacation.

0d5dc5818191 ("soc: qcom: ice: Allow explicit votes on 'iface' clock for ICE")
stays queued for 6.12 on that basis. It closes the gap the four DTS commits
already shipped in v6.12.97 opened up, and I confirmed it's harmless on the
6.12 nodes that were never converted (sm8550, sa8775p):
devm_clk_get_optional_enabled(dev, "iface") just resolves to NULL there, same
as mainline.

>The 2nd one should be taken to make the DTS patches comply with an updated
>binding. [...] However, the patch must be adapted to 6.12 to not make the
>power-domain and clock-names mandatory for Eliza and Milos since those
>targets arrived in 7.1 kernel. Only the first portion of the patch is
>applicable for 6.12.

Agreed, and that matches what I see: the allOf/if-then block in e27264daac7d
keys on qcom,eliza-inline-crypto-engine and qcom,milos-inline-crypto-engine,
and neither compatible exists in the 6.12 binding's enum, so it can't go in
verbatim.

We don't hand-split upstream commits in the stable queue, though, so
could you send the adapted version yourself once you're back? Please
post it to stable@vger.kernel.org targeting both 6.12 and 6.18 - 6.18
shipped the driver change already and has the same binding gap.

Thanks!

-- 
Thanks,
Sasha
