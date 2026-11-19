Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795077845;
	b=sr/US9gvVRCfnKL6MTXztpZ5YCuyEGuB3EP+Qlqx6+SSxF8ziOP6jZnfTHRxpxpgvrF8
	 ZzQz/wPX8BwSU6JYAQp5uMK471VM5aq1dMs69jSlxVUAoa+MtH3sYODjaPvwFALT2eywX
	 kUJ9UAyRqYbu0oB10UQOSa5R63A5ODz/bRFe+4vuV7yOUrrjVhRinp9EVX5FMszQHz0of
	 Nnry0UisNPMQ3WIWkKiWzGTaqL8Q5Hn44DAr1Dy/M5wbtIiGm0QAZSuVtEf91Y5qmFfYN
	 fzZP6tpiaRbIVd1UhIe7fTmSh4xZK83GJA2wGLZ54utyNlndcsfrGetCNlCBwEWK0Ww==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795077845;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=m3i+HRIGIUiqcgfax9l6q9GaA7Wh6NDEMTSkux3S4EM=;
	b=SjeUMBwnStk7AEqU0KBVcyL5/M7wCpab8UxOZeOwTGqbzZIE0m4aBxmiQNRcwq+9mBW+
	 3jsJh5Cup+wINXTrMC4nAOfiKQIJuz17U6eFy/8cTyNN1tiUy15uFRbzeeOHKCRJU1Ko7
	 WAf1OxyYEWBzyWO5n6cmB0KHvlvqivzu+T+yOlQCUmaW4rb7tiATBnbwQga+FGS3/CLAi
	 GzVcFLg/I/tIYAbxDKoK2nsq9BiIFeVr8BJq7mbaCjvJbpDbxJ0ijTDfVYgv0+dgXqmQn
	 +Uvkc+l1BmKBX5l71kwg0J3LtoqUwQY3Mrx7oHi82sgLEq+xy23v3p41WYHv9vS0FjQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=G5eqQk+r;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59A3606A324
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 08:44:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C59A3606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=G5eqQk+r
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3b0bbdeae06so1119420a91.1
        for <patches@lists.linux.dev>; Thu, 19 Nov 2026 00:44:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795077844; cv=none;
        d=google.com; s=arc-20260327;
        b=CK7N0dUTGVwHsz6XlsrXY+BWdj5ccYKPjp0hpnTgG0pIyidoJqRulmr5r+HNSCn0pC
         4JixeAZgUUvltefTfPcr2g9nyC/cU+b1+LwYmaRjtdpulfX6HV1AwClcoY5vmmhlCYJm
         VxSydCQOmHDl1m2IfBj+0CJb6UUWsevBCFVmpH/Y+m6kfrv/NsY4vDjBPxSprrjxsWUY
         y1RBDaBfcDG7yFHR3iuGPlqn6slXevgXbXiZ9EQgMjtvv12dx/PK6Aff/SM5Oe3IF1Zz
         QNFwx3PWyYPOCJdtDAnoFHorxj+/02rAvMJT2x4KfVIuSt+viioDPU/5EXl6+nuJqSn6
         YGUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=m3i+HRIGIUiqcgfax9l6q9GaA7Wh6NDEMTSkux3S4EM=;
        fh=/inDRrSqTMSMamWJLJ5Mqxc09DHrL4Q3DkGnRj+6Xwk=;
        b=UGPsJUcBe0AcccEFrqHXglrVhRHtrw6aaeclma38J/oF0+tT0o5Zars8+HDp5VDO2N
         kQq8+ETpGlfk5jKnTNPEFfGrrPt+HPJfezIWflJ3a2xr1FArWwZR+ad2uGniBBV9IuHg
         ExplG47ngMt5refHpf6S9kGziBqD2SYuuEhD4HRP3QAXatYcwz+hZMGJ7rkITfocnUHq
         2pkCG6UFOEpJZPChx9FFYaLrUQ1Z1ncD53QcZaLkWCtS1b04DBwintCUn4c7XJLGbFYc
         lZGViE2bg0AniAZoJOejTzMTzBzYS49Z/OGOtMuGguYkqNzJjv2FSiMaxgNFUV46HKQo
         +nRQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795077844; x=1795682644; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m3i+HRIGIUiqcgfax9l6q9GaA7Wh6NDEMTSkux3S4EM=;
        b=G5eqQk+rlLMGtCx4nJFik4hKY7DpQknnns8RRcdQJUvI78vP1KnUjDFRaHVykjcz9E
         OHpfUEzG2LJ44+s1tYmVuK0xaSToX+WlHk7tLSm7HA3vD8BDG4zzqXcRsoqN8gD7AbT/
         Ggha/AWS8LVJ9EARSDyNCaMySQej1PkuMP6WAeBCc/xeDqRI8pHZymlZu/BfOrMT54CB
         U97I+PQHQKsQLHwIB71+N6E19r9kdIiqyWUb11zZ8wSnpGNv26bScTmjgqV2Y8phhfBa
         xgPra8a25muOdPvlbPDhvmP3SmYbn3PQpNKI8gJD1gOg/liauER2JJweteOasnCImLJp
         WiEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795077844; x=1795682644;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m3i+HRIGIUiqcgfax9l6q9GaA7Wh6NDEMTSkux3S4EM=;
        b=SSrFcViCwdg/O9C/EOajGgQa2o78j/ZGEeICGzBK5ekclExa+uW3fr29KOJx7WXyNN
         Vrj4h5ahHe6Gwfeh60p5z2batB+UnJvhXj7pZCsITFScY+tmY4oAWnMhR35475T99DLX
         xW4uVvRd9rGkijrWDU3YtzxDZt5DB+H4TLZe3ChKbJY0VSoNPeKTKZORCpHnTAlubGhz
         kLxUdOBeuPn0fwuffAIG4VbhTe8d6MTqS0In0xLB2PZEA3NStnctekZNxFXxRZMGyWNy
         cirzHkZyLNMP9vZT/Y4RE1Zkx/Phnnw9yM1TxRP/R7BInfZu4/bFQImSBqjwS/LmqRyl
         68BQ==
X-Forwarded-Encrypted: i=1; AL+hErHHKZ90TKB2/fd7ETTTnrfvdSU8Vyl2+zV4LXHitbcfTYIwXU/3eT128/+CZ3E9ZmRIQeP2xSfM@lists.linux.dev
X-Gm-Message-State: APuU4Z9MHA12Aocm7GyaPtMg3aOCBbbkFT7Vr7IYVSLuyZSuU66DqeJW
	1UfO1EL/sZdPIfuO5s4w83Z5yGlf32zsrhDyXnA9yPiO7KYoei6giLkflBJ8hGkiLWFtVLHrzHq
	nxxXuPcVuH69oivnIXt1EffBI1XuPQg8UxvYo
X-Gm-Gg: AZFdTZeFrTXprGP+vwWl+Q19x//mwXfMGt3cMLaJpENBks3q7YWRsbsEN7SVwUvynYS
	QdFAihbvrWsySnkqHQs3o2iMC5wKnR6JYtg8LhTFC5ll7r8kzP1iBRv9nUDu0xY7I2DeBmDkr20
	gNwqbK4zmKLXigIFsbgx9zpVX53fG59fL7/0laT2QjXzZebH/2z3VRFeQ41mW0+cK1eLKKBbSbA
	OUEqoxXsGIcv3AZ5PjHakWySKGDELMUD8yvk1Z3Lm16ODXh2SbZ7q7QFMxomXcnzN2LX/OA+Z0O
	wKf1I5JK9yU/xoRT5kTHLDY+BuSDDph92TMLXR3Ce0mCC6MEYZvyhRsRRLz56eO4yqn+APOeWWJ
	y1uWGQuAb8VEPEUDxwaV57zyMjjq9CWzakRLClIDBOYZf0njb3Adf/ev9h2s9ZIpB6guWYKaxLO
	dytIu4K6g25PkhGz6RE+4=
X-Received: by 2002:a17:90b:55c7:b0:3b0:ad59:7199 with SMTP id
 98e67ed59e1d1-3b3d07c653amr4418993a91.32.1795077844104; Thu, 19 Nov 2026
 00:44:04 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261118150247.972732815@linuxfoundation.org> <20261118150355.645960710@linuxfoundation.org>
 <fd52d21a-34c3-4686-a9d1-099933e7cae2@kernel.org>
In-Reply-To: <fd52d21a-34c3-4686-a9d1-099933e7cae2@kernel.org>
From: Semih Baskan <strst.gs@gmail.com>
Date: Thu, 19 Nov 2026 11:43:52 +0300
X-Gm-Features: AclHuK8QPMFHYltRaH7S413ogSf_lQahbS4zUjRoVVdhquYP1vCMz_GsTwBswJw
Message-ID: <CAAsRjRmbj+f_v8d99EgGi_z_rfmw+0rnKN8Y2ZwuHarPKP4NEQ@mail.gmail.com>
Subject: Re: [PATCH 7.3 1913/2651] PCI: iproc: Use the EROM outbound window on BCMA
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, 
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 19, 2026 at 08:19:21AM +0100, Jiri Slaby wrote:
> On 18. 11. 26, 15:52, Greg Kroah-Hartman wrote:
[...]
>> +    ret = devm_add_action_or_reset(dev, devm_pci_alloc_host_bridge_release,
>> +                       bridge);
>
> This does not build on armv7hl:
> drivers/pci/controller/pcie-iproc-bcma.c:72:45: error:
> 'devm_pci_alloc_host_bridge_release' undeclared (first use in this
> function); did you mean 'devm_pci_alloc_host_bridge'?

This needs commit 39d1c645bb99 ("PCI: Expose
devm_pci_alloc_host_bridge_release()") from the same series. The two
apply cleanly on 7.3.5 in that order.

Best regards,
Semih
