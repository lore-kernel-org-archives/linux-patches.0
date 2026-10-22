Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.206.34.216
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792661569;
	b=Nc6CVrGAH61I5spxn291zqfq1lSFukUdxlA4kyrrNitpZQ4vLmxYIpC2UrMNn7sw+Bqy
	 XC0aV/OUznoVKPOeO+OS0KB/HJCD/RPgXDG4wyIqsVPSh/6npZ/JdRx1dpVdW/IwbVSES
	 Wl0tElWBryPwwo/hW6jV5GwSr5txhw8lULg5uZGtR5soMzHK038rcu30ZfDSlJHoGhYJ3
	 8K0BMxAA/0j3P86YptJLp/3ed42MV+FBoLvuuq2DXpF6r3wKNZLoYYhCppRoPtOYbKTto
	 GEkv1LcHyUxBD6DdUoFaY/wMksiD2EGmmUXj2CdBoHEccnnCf2pkXv1DHh0jEPsJcYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792661569;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-QQ-SENDSIZE:Feedback-ID:X-QQ-XMAILINFO:
	 X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=MNO86/vPNqNj1ipvoo0nLkf4S6QTI8ifhfqmHv8QTLc=;
	b=i4r8EyWJz4PFcOxrkzbHr4OL/3iZaifJbHGt+fLC4M2L0YfLnMxVBJVWc4WxwLk44CId
	 2Hu3PAwqXpIpzQcHJzDa8Fdyl0Z2iwNLLAWhqkxWDzKcXEkjNom0LGeGlpPaT0Tg49smJ
	 fvcRWSfE5UnR/H9Ge2Qy0P/DvajygVcYNMYlW5hPSXlb1+r1yG5ieRi7VmGB3cGdv8o8n
	 L66hiP7yYCnHKNTkFjGX3ybcwPVM5idCjagVqL7ZSAkOyjgTaCeY9cGDQpXaHbxZWCLKc
	 BEx/EI2Uz0opRKa/YJphKz5MYPcGsBE3EUEv+xfPZ3bqqZVoAYhGWQsv+JjjHGjaKOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux.spacemit.com;
	spf=none smtp.mailfrom=linux.spacemit.com;
	dkim=pass header.d=linux.spacemit.com header.i=@linux.spacemit.com header.a=rsa-sha256 header.s=mxsw2412 header.b=X0XWt5ef;
	arc=none smtp.remote-ip=54.206.34.216
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDBE606A31A
	for <patches@lists.linux.dev>; Thu, 22 Oct 2026 09:32:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFDBE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.spacemit.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.spacemit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.spacemit.com header.i=@linux.spacemit.com header.a=rsa-sha256 header.s=mxsw2412 header.b=X0XWt5ef
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.spacemit.com;
	s=mxsw2412; t=1792661527;
	bh=MNO86/vPNqNj1ipvoo0nLkf4S6QTI8ifhfqmHv8QTLc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=X0XWt5efgrf16/36sevCEXi6yunRWAcucw825CKt1LPupt3ONBsTaYTaBeFVr46nF
	 89oAuMdGdmfpwPnIHopjLBnWitATyAS260kcxADP7y1gA5HD7hpfTzF+oz3b2hO+8g
	 EdOdBwcH6yUeyPJ/sArS0EdCAyGoVpZAn94dfhtU=
X-QQ-mid: zesmtpsz4t1792661521tf8c4d186
X-QQ-Originating-IP: dPy+WkuC9bdncRwOP6S9bDiBeHuFCmOE3cM24EOhmeQ=
Received: from SW-U22IC-015.dc.com ( [120.237.158.181])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 22 Oct 2026 17:31:59 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 12619411188459355194
EX-QQ-RecipientCnt: 8
From: Peixin Xie <peixin.xie@linux.spacemit.com>
To: sashal@kernel.org
Cc: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	peixin.xie@linux.spacemit.com,
	rafael.j.wysocki@intel.com,
	rafael@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-6.1] ACPI: scan: Defer device power initialization
Date: Thu, 22 Oct 2026 17:31:58 +0800
Message-Id: <20261022093158.739937-1-peixin.xie@linux.spacemit.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019135441.1420968-273-sashal@kernel.org>
References: <20261019135441.1420968-273-sashal@kernel.org>
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
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:linux.spacemit.com:qybglogicsvrsz:qybglogicsvrsz3b-0
X-QQ-XMAILINFO: OC9B+nDkeCKkI9jAP7HbmnP3PO7SHXtCwDR6cXqg+/YW6pEM8g68anKk
	qROa5eHOEw7NRGKKuv/m0MV3VtfWAFoMKlmUl/HJsbP8XncOLyGbF7WjJbyVFZREGVMe6yj
	SZuO1kO9EzfjiPwyVZlFA5eXV+UZL5zjhldM2YSB2LPfRI2J6a16VokQEH78aDS2kw6CWIY
	QFfnwVgVDVmj7nKjnoWVHOVpW0notiuM1spT2Wgi6rwuva+VnHNcJkGgkmPii661KwtGdWX
	uGjW+3RZ3kUTrQ+X2RxrtNX1Dj9HlnRTHB3XvHJD+zfsThqLuI5wR4vNa3cxyS8Vq04HUQp
	/cUhz9ocmLC5O5p7B47t6v6rmpCZVobZ+1HLAyNgltFHBRp4HMyNpiPN5oHZSVoglrt7KGf
	1XafMpJ1LzYe5fRspSkHyYj4jckuWAFiKNdFlzydI+H1AAvgoHHvwfcjVLL+NG3LfuWEVuV
	/kzSod1Fgvk7Y19zxUjcyGF2xIe2w+S43wdIP6rgv994bj/oPmBaeW74KsN3IEh03oadhZb
	I/jKr9PzcrYDIIz84mwvyLUnKbKguloTzGGrfCF9vumk0V2TEBvTcSfaMfrUFaqRo0OZ56O
	+4W+1OUV7DnR+3Ye3CeAAXCY/BkImD6y/+LwSognyx4v7EEclMnW5RKQfXl3Vmmdd/jxxcq
	bjZK0vtcL5LbbtkzmkNBZ8JMFtw4xpmyYdpFAP7orowQ+E1IIDv82LGYyWmurxK8UDZ1lSF
	LcdyeW95WnqP5VHBpgKcVKUmtZgR1+Px99S/jIc+JVyDSxD01b3v3DxK3V81UiERDVETS+r
	M/YvfNlIV6YOqMGc7hzuQXFVEadHCOg1YHSlb/N6NgDSvGCWfQysWrQIyGJr3snhO9/8u64
	IU9RoDCXbBs3HWU45GNhH/Fyho/PYgf1+pwUOyOEsJoe4m2aOsVOID9ee88VijECXX+PWUN
	SvLQUg0qIUjZOpsJ8UehPzhNygYIUlDe3MXWLFvnS+Dq3BoC1p3yGcFHuFD9o755U8zWISj
	xlxzdFiSZ/FoNVV6BZGgBEdGwbQOjHpHvGO0Uy2VTkdC04cQSH+uUs6wFmoRN3dsROqf9hh
	6+rNZb8M/jp
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

Hi Sasha,

Please drop this from AUTOSEL for all targeted stable branches.

This patch has been reverted. And Rafael has started a new thread to
discuss a replacement fix.

Link:
https://lore.kernel.org/lkml/6029658.DvuYhMxLoT@rafael.j.wysocki/
https://lore.kernel.org/lkml/6044499.DvuYhMxLoT@rafael.j.wysocki/

Thanks,
Peixin
