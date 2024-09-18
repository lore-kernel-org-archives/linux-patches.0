Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442C419A;
	Wed, 18 Sep 2024 02:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726625146; cv=none; b=eDwgvXBTwcNkFmRRQcMqrgqF1g3I2URnB/N0IbzL9Xq9YDnk/99Rz4Yk7XtyAn0C/DdnHxb1Mos5uZLusuWQRT/AetzPA/2j4iWSiY4EWcbktaK+3WNb0eodDhTezxxxRZLpCEuJI644lrbgqw1swkmYbtpWoXFU5nF16WopPpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726625146; c=relaxed/simple;
	bh=ja0bMnkN4tal4/Qm2vECx9zbDlKn9vDet4Fh//EDTdM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PcC3yAgPeuHhoT+TAHAUDvs2WIw8qy9gqsYfV1Las8aE2ybr4US9v+qY6O7E75DajEABynoUXObso+n/ejJXRk7hINYEPWEzzCjF/WgdKcXuhEtpgCV7e79xUHE8pbv9O2r/t7rA1Pu+1TpzE1hXObHTFMUVhUJqlgaQxvsWZKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.184])
	by gateway (Coremail) with SMTP id _____8BxfeptNepmmmUKAA--.24559S3;
	Wed, 18 Sep 2024 10:05:34 +0800 (CST)
Received: from [10.20.42.184] (unknown [10.20.42.184])
	by front1 (Coremail) with SMTP id qMiowMBxHeRpNepmN0EJAA--.53205S3;
	Wed, 18 Sep 2024 10:05:32 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Ensure ret is always initialized in
 kvm_eiointc_{read,write}()
To: Nathan Chancellor <nathan@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev, llvm@lists.linux.dev,
 patches@lists.linux.dev
References: <20240916-loongarch-kvm-eiointc-fix-sometimes-uninitialized-v1-1-85142dcb2274@kernel.org>
From: lixianglai <lixianglai@loongson.cn>
Message-ID: <9c7e4360-3f77-035f-edb9-61dcfe239a29@loongson.cn>
Date: Wed, 18 Sep 2024 10:05:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240916-loongarch-kvm-eiointc-fix-sometimes-uninitialized-v1-1-85142dcb2274@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID:qMiowMBxHeRpNepmN0EJAA--.53205S3
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7ZFW7KrykZw4xJFyxurW3urX_yoW8ZrW5pF
	1UZw4kCrs5Xrykta4Dt3WrWF4jqa95Gr17uFyYqFW2kF4UZF9xZ340yrZIgFyYkws7Jr40
	qF1F93WYvan0y3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1QVy3UU
	UUU==

Hi Nathan Chancellor :

Thank you very much for pointing out the problem,
I will integrate this patch in the next version.

Thanks!
Xianglai.

> Clang warns (or errors with CONFIG_WERROR=y):
>
>    arch/loongarch/kvm/intc/eiointc.c:512:2: error: variable 'ret' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
>      512 |         default:
>          |         ^~~~~~~
>    arch/loongarch/kvm/intc/eiointc.c:716:2: error: variable 'ret' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
>      716 |         default:
>          |         ^~~~~~~
>
> Set ret to -EINVAL in the default case to resolve the warning, as len
> was not a valid value for the functions to handle.
>
> Fixes: f810ef038c66 ("LoongArch: KVM: Add EIOINTC read and write functions")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   arch/loongarch/kvm/intc/eiointc.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
> index 414e4ffd69173dc248ba0042bed3bebdc11700e3..e5d23f0da055c97c0e4ba6705f6b71d89846f42a 100644
> --- a/arch/loongarch/kvm/intc/eiointc.c
> +++ b/arch/loongarch/kvm/intc/eiointc.c
> @@ -512,6 +512,7 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
>   	default:
>   		WARN_ONCE(1, "%s: Abnormal address access:addr 0x%llx,size %d\n",
>   						__func__, addr, len);
> +		ret = -EINVAL;
>   	}
>   	loongarch_ext_irq_unlock(eiointc, flags);
>   	return ret;
> @@ -716,6 +717,7 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
>   	default:
>   		WARN_ONCE(1, "%s: Abnormal address access:addr 0x%llx,size %d\n",
>   						__func__, addr, len);
> +		ret = -EINVAL;
>   	}
>   	loongarch_ext_irq_unlock(eiointc, flags);
>   	return ret;
>
> ---
> base-commit: 357da696640e1db8fc8829a4dd1bb2d0402169b5
> change-id: 20240916-loongarch-kvm-eiointc-fix-sometimes-uninitialized-e17b039d2813
>
> Best regards,

