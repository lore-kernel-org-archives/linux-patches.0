Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DCF26A1DD;
	Tue, 19 Aug 2025 06:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755586585; cv=none; b=n4XIjDHIU63RicQeA9x3qsQdPP8bF9CWyUvMWCCYgIRfqcoDsEKuJgQkc2LRccrTmaa8dWBM4uhnNUqkkdX1kifkwYelj/cvnlNZVzIieom5ozL3ryshD1vijxScSwoKax/OroJir9OSNvyExP6Stg619hGAnagg6WdfH3wveJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755586585; c=relaxed/simple;
	bh=H6K+qEWhflAu7cNo7Du6hhX5mK0xaPJlPOCQyjH9sTo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iGtnDcQdXGSjG2vHnMPM/Mr+AJK0BXo/JRe1V0ksniyPmaK33QJ+vaTwUOmQaBzucs1m2YrjtHXqeviEf54FQhfE8+J6LHogoi6k8LWb5R+4ymEM/E6d1cMBDugNpcJLhjPeDMCAcRN8wV/+vxLSakPyryjf9wXR72kM36eiXjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=Bzk8t+mr; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="Bzk8t+mr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=6St+hyO51QOaKSkLJ+t4fE+Zvd3kQPanMdycFpK8qoc=; t=1755586583;
	x=1756018583; b=Bzk8t+mrSExjsh3yIhB7OruBHOzTWGofFv72d6HlxH6f9oxeg9+mvzQ8mJnwq
	JnRhRVZrcTJnGfDv/5E8KOQZuWdi3T++HyfGgyt/QdXAlgisiY6op+Ex/Q0kPv2L7TWXHVYsDerTK
	BFK/8e6BTJaYJEzCMqWA+ot+HuwEPKRJ+tNYluQyVP08W1oky5Vt8riY6GxC5dqqorCFFNigH1oD7
	o8YhS7uCajqG8rv4wQc56d/SgJE/gTlO22eY9peHbRefueYLHNwnB877uuIFyYCdJWZKzt20MPqha
	Qpctxna6NyeA8CyNmA2o7vmVgAzP5eXsLia8mOnz/4Bh29+UTg==;
Received: from [2a02:8108:8984:1d00:a0cf:1912:4be:477f]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	id 1uoGGb-00FxbS-0P;
	Tue, 19 Aug 2025 08:56:21 +0200
Message-ID: <9ac42b4c-5cae-47f7-98c4-ffe0d5194e67@leemhuis.info>
Date: Tue, 19 Aug 2025 08:56:20 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 209/570] bootconfig: Fix unaligned access when
 building footer
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ben Hutchings <benh@debian.org>,
 "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20250818124505.781598737@linuxfoundation.org>
 <20250818124513.854983152@linuxfoundation.org>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 n7RI
In-Reply-To: <20250818124513.854983152@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1755586583;76584ecc;
X-HE-SMSGID: 1uoGGb-00FxbS-0P

On 18.08.25 14:43, Greg Kroah-Hartman wrote:
> 6.16-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ben Hutchings <benh@debian.org>
> 
> [ Upstream commit 6ed5e20466c79e3b3350bae39f678f73cf564b4e ]
> 
> Currently we add padding between the bootconfig text and footer to
> ensure that the footer is aligned within the initramfs image.
> However, because only the bootconfig data is held in memory, not the
> full initramfs image, the footer may not be naturally aligned in
> memory.

This change broke the build for me in both 6.16.y and 6.15.y (did not
try 6.12.y, guess it has the same problem)[1]. Reverting it or applying
26dda57695090e ("tools/bootconfig: Cleanup bootconfig footer size
calculations") [v6.17-rc1] fixed things for me.

Ciao, Thorsten

[1] see
https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/stable-rc/fedora-42-x86_64/09440377-stablerc-stablerc-releases/builder-live.log.gz

main.c: In function ‘apply_xbc’:
main.c:442:41: error: ‘BOOTCONFIG_FOOTER_SIZE’ undeclared (first use in this function)
  442 |         static_assert(sizeof(footer) == BOOTCONFIG_FOOTER_SIZE);
      |                                         ^~~~~~~~~~~~~~~~~~~~~~
main.c:442:41: note: each undeclared identifier is reported only once for each function it appears in
main.c:442:23: error: expression in static assertion is not an integer
  442 |         static_assert(sizeof(footer) == BOOTCONFIG_FOOTER_SIZE);
      |                       ^~~~~~
make: *** [Makefile:21: bootconfig] Error 1

 
> This can result in an alignment fault (SIGBUS) when writing the footer
> on some architectures, such as sparc.
> 
> Build the footer in a struct on the stack before adding it to the
> buffer.
> 
> References: https://buildd.debian.org/status/fetch.php?pkg=linux&arch=sparc64&ver=6.16%7Erc7-1%7Eexp1&stamp=1753209801&raw=0
> Link: https://lore.kernel.org/all/aIC-NTw-cdm9ZGFw@decadent.org.uk/
> 
> Signed-off-by: Ben Hutchings <benh@debian.org>
> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/bootconfig/main.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
> index 8a48cc2536f5..dce2d6ffcca5 100644
> --- a/tools/bootconfig/main.c
> +++ b/tools/bootconfig/main.c
> @@ -11,6 +11,7 @@
>  #include <string.h>
>  #include <errno.h>
>  #include <endian.h>
> +#include <assert.h>
>  
>  #include <linux/bootconfig.h>
>  
> @@ -359,7 +360,12 @@ static int delete_xbc(const char *path)
>  
>  static int apply_xbc(const char *path, const char *xbc_path)
>  {
> -	char *buf, *data, *p;
> +	struct {
> +		uint32_t size;
> +		uint32_t csum;
> +		char magic[BOOTCONFIG_MAGIC_LEN];
> +	} footer;
> +	char *buf, *data;
>  	size_t total_size;
>  	struct stat stat;
>  	const char *msg;
> @@ -430,17 +436,13 @@ static int apply_xbc(const char *path, const char *xbc_path)
>  	size += pad;
>  
>  	/* Add a footer */
> -	p = data + size;
> -	*(uint32_t *)p = htole32(size);
> -	p += sizeof(uint32_t);
> +	footer.size = htole32(size);
> +	footer.csum = htole32(csum);
> +	memcpy(footer.magic, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN);
> +	static_assert(sizeof(footer) == BOOTCONFIG_FOOTER_SIZE);
> +	memcpy(data + size, &footer, BOOTCONFIG_FOOTER_SIZE);
>  
> -	*(uint32_t *)p = htole32(csum);
> -	p += sizeof(uint32_t);
> -
> -	memcpy(p, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN);
> -	p += BOOTCONFIG_MAGIC_LEN;
> -
> -	total_size = p - data;
> +	total_size = size + BOOTCONFIG_FOOTER_SIZE;
>  
>  	ret = write(fd, data, total_size);
>  	if (ret < total_size) {

