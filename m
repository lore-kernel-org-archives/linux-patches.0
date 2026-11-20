Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795165204;
	b=rjv5HPO8/X/vn8xJkNOlLU3/LuUpq0aT+dK0szLU22ZNxuqBmTbPgK5JttnxajYJQqri
	 GJcJvKVMPtgpOW6hf0C8jsc1n0GZ3x2g9UL7P/GXxv06VtcCUXNX0etGEsPHkGTsneDVQ
	 H6le4bq4wX0pFLoxG1VCYZ6jM6JbeV1mJTziVDp3fw9wAibQAnleLCR3s4skCnj2yR731
	 M5+KUwhrWGtXu21j7MxJKLQMiUzhHEgsWlnDBH5oMFgU+6JJ46iVRgJbM5VSneFjLiYh9
	 LY4DaFiVYsipFby6KjKZwzQjcw8OAy0BjP0lz/uMX9QHi+5tluSjDAJneeCABTAj0lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795165204;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=5NSy9VUbR/SX8a1pHNb7IdxpnGO7bEH3/Aun+Fy4hqE=;
	b=EeCdLXxXWLOiYGrI07MutGkqbXcoeET1Ze6U3OObgKS6GGg4ftwdEtV1QxiIqlLshpAN
	 19wal+y0hqisWUIm+TMb18qT9nVmHwUjEtz9nWbXvskZTY1WvB9bTDbkgTcTJ8LW+TmP5
	 iqWV4yMFgwXyzlH8i+JMlfcaiKEZikJpaSJDZS2Xy4QHCgQOawhJOzWY3IHL0jrtnL0JR
	 YUGBOPKZlKVwckRX7s8iek+x3RtIKoGK6QpP1JkUNVTzwKwSqKgiUQIdLMUD1tlWeYByH
	 qbZlhXqO1Fag7nNpvTvTf4FRcf5ezs4B6Ph4iGflwKarn3ON90Ny0hzFsQK5YnWqKCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=debian.org;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RepgOIi7;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D622760A6F70
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 09:00:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D622760A6F70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RepgOIi7
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so4360625e9.0
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 01:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795165201; x=1795770001; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5NSy9VUbR/SX8a1pHNb7IdxpnGO7bEH3/Aun+Fy4hqE=;
        b=RepgOIi7dx72bb9uYjsMVFh6Nr95d5B/yg1RvWe2w1CBfqfnYFRdTA/SYLfjTFVklx
         p4uGX6x+xLtjESpCEjkCLcWkxYj/Et+QhHY3HVoO9oMZFv8Shdra/ghyYfBW6hRjnvgc
         TXoF9dbVG2/PjO6FKC1KYzg+Txn8kTTfT2GyaDpaL6rilbxVl/YcKrj0jAfmpY97Qlaz
         /JA87al8HUwEiH7JpwSEZs+tIkbzTgj64cNDZ3uppui+H/IQTyQHeas3uFiSqdCUXOMD
         P4+KLiUygbqcppGGZueXumeW2J918yTJfqsA1vjc3FGkjiusvDA3Mlu/bHtnjpKTfpkK
         oqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795165201; x=1795770001;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5NSy9VUbR/SX8a1pHNb7IdxpnGO7bEH3/Aun+Fy4hqE=;
        b=KBzDHSTZyuf5wgg37dpC6q/V29QYGh9+TQMUuBTMbXpBCZ8UNs2T5YyattNwndUK9C
         yDTta3QbfW4vvg4aN4Z6QXD0A3ZkblzkhCwZQtenCQjAnF0XejUiv5mlBKGYXnwgpQcm
         QZQLZCM9hsmulUTfp7wboPvcmUF0Xk5PHPWR7gE49aAsvZ2uFUEdRfew20MJiNSvGxSu
         koVg7eL9cU8iwS+NMBDfLgpNhodMSrjuy2swDp3Bm1mm9Ea5aqCkJO+VvkYHUJq2Kq80
         8vIzQxe3aXGrNNZAq40LkSnpyWANSGULowX2+GEzmgmRY5v49hgwOqFlbmgxgjfX8y3y
         2F6A==
X-Forwarded-Encrypted: i=1; AL+hErFITxQbW0a/BwtSUaHmhE25fy+Hta7V2pPy54J0ihJk5CM9J1kBGCiUrP7t1WU6CgGsq9E1oPrF@lists.linux.dev
X-Gm-Message-State: APuU4Z9XThdtsx+PEnLxDj++CoWJe+7ek4G0p6IzqIJeC9gp4v7IGXaH
	BcyVYi/eSVGIi8F+ldZKRCyhMLqYs0q2Jw3nobSklyBbzKYuih7R6LDv6vp5hWxF
X-Gm-Gg: AYBFou2SdMfRWGF4903TQC4Y5Po4HHNKpTO5Jnzry82+uq0jtTRHIxHMfoLNXRCKJsL
	ec6dDPP7/ApQ/19mSHGBAMHCa9joSly7IIUIUkYo001R86aeSX+HPuBJGurlVkxEtX/67enulbT
	99LsXYcmeV9NjBPrWXqhBVv18zjVzuqHQ9W6JqhimOCxAwQ+TUauPZ1/SDzzxUU8TlJkjAF4Xy2
	xG60Lv9kDF+hpCVNLK7Cb9fbDaSk16TDOOslWwMDYttuBBmnkZjVFuu68R0EbhAVyJHlQXTv79I
	tjre4N4O9VEUMtbt654uBdpyiexdAza0X4YufTTqKChL71TEJxbefWjbY0Sotdg9WPSkrEux6N0
	Z5OOMQx8LUZ9kaaNjE3LebOAzaN26XggJq7VNWKnSJWPvd0Xrzl9AtEHcLqvh/z9GZbK4Cz8tVe
	ULdHtm65XdcQZeOPjLiRfe+e7bc2goP8q7YicPbQIJWDRkv2rqqk3U9xGTVn+2/9QwkhzHPz9G5
	MKkjijY2JgFGWTztI5J459lp+lyb6mfaBWOtAB+xHO0VwMeW0YRR158MhlqJ32IwwXdjcZkJzfc
	8xs+OOxXu9EMWuJPb+nEu0qiXPT+4oRS9upjWznKYc3JCxiI2f92DV/FjeV1uu4C
X-Received: by 2002:a05:600c:a15:b0:4b6:267a:dd6e with SMTP id 5b1f17b1804b1-4bb88938a62mr48117625e9.28.1795165200875;
        Fri, 20 Nov 2026 01:00:00 -0800 (PST)
Received: from eldamar.lan (c-82-192-247-196.customer.ggaweb.ch. [82.192.247.196])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf629dsm3971885f8f.9.2026.11.20.01.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 01:00:00 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 705B7DC06FA; Fri, 20 Nov 2026 09:59:59 +0100 (CET)
Date: Fri, 20 Nov 2026 09:59:59 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>, benh@debian.org
Subject: Re: [PATCH 6.12 0695/1756] perf python: Initialize debug output on
 module load
Message-ID: <awAMD5kuizXPSt-7@eldamar.lan>
References: <20261118150007.957976754@linuxfoundation.org>
 <20261118150036.866211196@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261118150036.866211196@linuxfoundation.org>

Hi,

On Wed, Nov 18, 2026 at 03:47:02PM +0100, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ian Rogers <irogers@google.com>
> 
> [ Upstream commit 3d13b3f1f3a7cd33d1847a4b87c3198089b6c4a7 ]
> 
> Unlike the perf binary's main(), PyInit_perf() does not call
> perf_debug_setup(). As a result, the first warning or error printed from
> the perf Python C extension hits debug_file() with _debug_file == NULL
> and emits 'debug_file not set' without a trailing newline before the
> actual diagnostic message.
> 
> Call perf_debug_setup() in PyInit_perf() and add the missing trailing
> newline to the fallback warning in debug_file().
> 
> Fixes: ec49230cf6dda704 ("perf debug: Expose debug file")
> Assisted-by: Antigravity:gemini-3.1-pro
> Signed-off-by: Ian Rogers <irogers@google.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/perf/util/debug.c  | 2 +-
>  tools/perf/util/python.c | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
> index bd968b4883cbd..5b53c9f8ec66f 100644
> --- a/tools/perf/util/debug.c
> +++ b/tools/perf/util/debug.c
> @@ -55,7 +55,7 @@ FILE *debug_file(void)
>  {
>  	if (!_debug_file) {
>  		debug_set_file(stderr);
> -		pr_warning_once("debug_file not set");
> +		pr_warning_once("%s not set\n", __func__);
>  	}
>  	return _debug_file;
>  }
> diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
> index 66d3b0c633b25..7b9b6d464a3e0 100644
> --- a/tools/perf/util/python.c
> +++ b/tools/perf/util/python.c
> @@ -1371,6 +1371,7 @@ PyMODINIT_FUNC PyInit_perf(void)
>  
>  	/* The page_size is placed in util object. */
>  	page_size = sysconf(_SC_PAGE_SIZE);
> +	perf_debug_setup();
>  
>  	Py_INCREF(&pyrf_evlist__type);
>  	PyModule_AddObject(module, "evlist", (PyObject*)&pyrf_evlist__type);
> -- 
> 2.53.0

This commit causes the following failure:

  GEN     python/perf.cpython-313-x86_64-linux-gnu.so
/home/build/linux-stable-rc/tools/perf/util/python.c: In function ‘PyInit_perf’:
/home/build/linux-stable-rc/tools/perf/util/python.c:1374:9: error: implicit declaration of function ‘perf_debug_setup’ [-Wimplicit-function-declaration]
 1374 |         perf_debug_setup();
      |         ^~~~~~~~~~~~~~~~
error: command '/usr/lib/ccache/gcc' failed with exit code 1
cp: cannot stat 'python_ext_build/lib/perf*.so': No such file or directory
make[3]: *** [Makefile.perf:739: python/perf.cpython-313-x86_64-linux-gnu.so] Error 1
make[2]: *** [Makefile.perf:292: sub-make] Error 2
make[1]: *** [Makefile:76: all] Error 2
make: *** [Makefile:93: perf] Error 2
make: Leaving directory '/home/build/linux-stable-rc/tools'


> 
> 
> 

-- 
  .-.  Salvatore Bonaccorso --------------- Debian GNU/Linux Developer
  oo|  ----------------------------------------- http://www.debian.org
 /`'\  GPG key ID: 0x789D6F057FD863FE --------------------------------
(\_;/) Fingerprint: 04A4 407C B914 2C23 030C  17AE 789D 6F05 7FD8 63FE
