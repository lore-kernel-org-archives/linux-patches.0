Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3438743786E
	for <patches@lists.linux.dev>; Thu, 16 Jul 2026 17:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784222446; cv=none; b=sdeHiGP4NAlC1OQEDua8cU7q/U9yOY34yOe1b6jBsC04T52hdhlkNxPeL+u+HbfacC/CSUINenTXZXOk6UBN7w1CvrLr/Gal4MzXqr//ZYhYBg7RNiFsE6/cgB0orilMoASQLhYroM09Rxfvw1CrhpOyFo0+uKETAIN2bxVCxgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784222446; c=relaxed/simple;
	bh=YhqI2NdXM75EMJ9o1ZhOgMLjtqSSEa4pHSQLKfB4X44=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZixRr3dvSi7DucJ4QAtdC8l9T2XSmYedG/ATL6M4NKHUiBRQojflsjXdCL13iF2TVadj2jbouy+lR5YGC76mKAWXD8pMMJt/j18I9kEY+76wdBLx5yhqphi7P+7XVxsNcZNZUonqEi5hhmcVhaAb4LWfMFOG2ScbRpkWRuwwblQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [192.168.0.110] (unknown [123.116.46.73])
	by APP-01 (Coremail) with SMTP id qwCowACXbfHkEllqgIglAA--.13292S2;
	Fri, 17 Jul 2026 01:20:37 +0800 (CST)
Message-ID: <777f4850-cfa8-4751-b3cd-2875f55c20e6@iscas.ac.cn>
Date: Fri, 17 Jul 2026 01:20:36 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 310/349] riscv: mm: Define DIRECT_MAP_PHYSMEM_END
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Paul Walmsley <pjw@kernel.org>,
 Han Gao <gaohan@iscas.ac.cn>
References: <20260716133033.287196923@linuxfoundation.org>
 <20260716133040.256132969@linuxfoundation.org>
Content-Language: en-US
From: Vivian Wang <wangruikang@iscas.ac.cn>
In-Reply-To: <20260716133040.256132969@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:qwCowACXbfHkEllqgIglAA--.13292S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JrW7CrWrXF43Gry3tFW3GFg_yoWkCrX_Xa
	ykW3ZrZFy7JFn2qayayrn3Zr4I934DGr15Crn2qrZYk3s3J3sxGFs0yFZavw1UW347AF13
	trZ8Zr4q9rnIkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb7AYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
	8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0
	cI8IcVCY1x0267AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z2
	80aVCY1x0267AKxVW8JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
	w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMc
	vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k2
	0xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI
	8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41l
	IxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIx
	AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2
	jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8Jku7UUUUU==
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/

On 7/16/26 21:34, Greg Kroah-Hartman wrote:

> 6.12-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Vivian Wang <wangruikang@iscas.ac.cn>
>
> commit f3336b48cf9d3f2d1fc78e3289c0ded2f00876ee upstream.
>
> On RISC-V, the actual mappable range of physical address space is
> dependent on the current MMU mode i.e. satp_mode (See
> Documentation/arch/riscv/vm-layout.rst).
>
> Define the DIRECT_MAP_PHYSMEM_END macro based on the existing virtual
> address space layout macros to expose this information to
> get_free_mem_region(). Otherwise, it returns a region that couldn't be
> mapped, which breaks ZONE_DEVICE.
>
> Cc: stable@vger.kernel.org # v6.13+

Please drop for all <= 6.12 (so, keep for 6.18.y, 7.1.y; drop for
6.12.y, 6.6.y, 6.1.y, 5.15.y).

The name DIRECT_MAP_PHYSMEM_END is only in use since 6.13 (commit
afe789b7367a ("kaslr: rename physmem_end and PHYSMEM_END to
direct_map_physmem_end")). It does nothing for earlier versions. I also
don't think it's important enough to be worth backporting for these
older branches.

Vivian "dramforever" Wang

