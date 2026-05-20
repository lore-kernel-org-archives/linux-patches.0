Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3273C278A
	for <patches@lists.linux.dev>; Wed, 20 May 2026 23:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779319749; cv=none; b=pfZOE6tTPGfCc5Qcpr+PQDwOC30Zd1CfYw3VXiHvxThkibWykq0ClMgG/2KfZ/jVZNU5QU3EMNfM1afyFDWmDDC+H9yeIzoBjXfCj/EEbLg1QZskZFw546gnHTVWOQ3ZbR7btd0F3IvDT9nnI4kTmtRJHbU4smMe2YshFutLSq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779319749; c=relaxed/simple;
	bh=liQbuJWeiZixIC2fg9p1TinVlqTVYlb/0O5h5heDu94=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MZqjvF1UTZ+2o/42lWbOk9exSStkGISonHkLJ4epKe01NrWMOCTtMi9m3pB3aSZbM5QwIBhwjN6ydgCkHgDXXROxRd37sN4NDhTFRPS0zbb73H5sHb417f9Ambw9AHt1PXy7W0/4CYBDZT1e9Mh+/D9jL3EhvFZG1a4uMKj5Zz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [192.168.0.103] (unknown [123.118.218.47])
	by APP-05 (Coremail) with SMTP id zQCowACHGw+2Qw5qO+nwEA--.7258S2;
	Thu, 21 May 2026 07:28:55 +0800 (CST)
Message-ID: <99c8c715-b37f-4f2a-8100-5ea4970ff34d@iscas.ac.cn>
Date: Thu, 21 May 2026 07:28:54 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 1102/1146] riscv: misaligned: Make enabling delegation
 depend on NONPORTABLE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Conor Dooley <conor.dooley@microchip.com>,
 Paul Walmsley <pjw@kernel.org>, Songsong Zhang <U2FsdGVkX1@gmail.com>,
 Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
References: <20260520162148.390695140@linuxfoundation.org>
 <20260520162213.183375345@linuxfoundation.org>
Content-Language: en-US
From: Vivian Wang <wangruikang@iscas.ac.cn>
In-Reply-To: <20260520162213.183375345@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:zQCowACHGw+2Qw5qO+nwEA--.7258S2
X-Coremail-Antispam: 1UD129KBjvJXoWxur4UJFy5AryUJFykWrWfZrb_yoW5Ww1Upr
	43GF12vrW5tr4xZF4xCw4I9Fy8X395Gr17G3yft34F9r90vry0vr9agw48ZFyUCrn5Ga48
	XrnxK3409FyDAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkab7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV
	C2z280aVCY1x0267AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
	Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
	W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l
	42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
	WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAK
	I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r
	4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
	6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07bYYLPUUUUU=
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/

Hi Greg and stable team,

On 5/21/26 00:22, Greg Kroah-Hartman wrote:
> 7.0-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Vivian Wang <wangruikang@iscas.ac.cn>
>
> commit b69bcb13ed7024a84d6cd8ad330f1e32782fcf28 upstream.
>
> The unaligned access emulation code in Linux has various deficiencies.
> For example, it doesn't emulate vector instructions [1] [2], and doesn't
> emulate KVM guest accesses. Therefore, requesting misaligned exception
> delegation with SBI FWFT actually regresses vector instructions' and KVM
> guests' behavior.
>
> Until Linux can handle it properly, guard these sbi_fwft_set() calls
> behind RISCV_SBI_FWFT_DELEGATE_MISALIGNED, which in turn depends on
> NONPORTABLE. Those who are sure that this wouldn't be a problem can
> enable this option, perhaps getting better performance.
>
> The rest of the existing code proceeds as before, except as if
> SBI_FWFT_MISALIGNED_EXC_DELEG is not available, to handle any remaining
> address misaligned exceptions on a best-effort basis. The KVM SBI FWFT
> implementation is also not touched, but it is disabled if the firmware
> emulates unaligned accesses.
>
> Cc: stable@vger.kernel.org
> Fixes: cf5a8abc6560 ("riscv: misaligned: request misaligned exception from SBI")
> Reported-by: Songsong Zhang <U2FsdGVkX1@gmail.com> # KVM
> Link: https://lore.kernel.org/linux-riscv/38ce44c1-08cf-4e3f-8ade-20da224f529c@iscas.ac.cn/ [1]
> Link: https://lore.kernel.org/linux-riscv/b3cfcdac-0337-4db0-a611-258f2868855f@iscas.ac.cn/ [2]
> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Link: https://patch.msgid.link/20260401-riscv-misaligned-dont-delegate-v2-1-5014a288c097@iscas.ac.cn
> Signed-off-by: Paul Walmsley <pjw@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Can we drop this 7.0 patch and the 6.18 patch [1]? There were boot time
crashes reported on latest 7.1-rc/linux-next [2] on some
hardware/firmware. While superficially it seems to be caused by badly
broken FW (one of the register dumps was a null pointer dereference in
the firmware itself from emulating reading the time counter, which is
essential on riscv), we don't know for sure yet and would like more time
to figure out.

In other words I retract my Cc stable backport request for now.

The file name for both are

    riscv-misaligned-make-enabling-delegation-depend-on-nonportable.patch

Thanks and apologies for the trouble,
Vivian "dramforever" Wang

[1] https://lore.kernel.org/all/20260520162154.619467251@linuxfoundation.org/
[2] https://lore.kernel.org/linux-riscv/nrvt74qnojaubiwjo37ums4lnclu466hovwrhmtbag6f5uhrql@q6msoe2oto4b/

