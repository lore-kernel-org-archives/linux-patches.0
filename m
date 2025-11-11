Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC6C2874F1;
	Tue, 11 Nov 2025 10:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762856279; cv=none; b=i85V73XRsw2OB0BDDMAyYYEdqF52DnY8qT6AGbM0Pym8h0h5MAEkYq9N552K8r4eopFJ2LbJiz2nkkAFOzWq3wB33knFi/klgUsPJjlsUDYQQQYyjJr7AD5sgKLipZ4EZhHtvEuzKkdle/RyIbKxceVBIagqnmV7N+w0JEytKrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762856279; c=relaxed/simple;
	bh=qFI86+fuHisehGJ2iOKF4S4CsMJEy6H8OTrI2Vu0IUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jpXWNH+24LU6ugrDBr6eMVZOAgIQg7cBJ4bnAfCI13vLbiZebSRyNl9FlFiA7pf9W6SQ2BcqABPvhwSBdGVJmfWfYuunHQ1Z6d6iF+UH1ZDTVZAiJMpPl1U01jBeif7Y7ghj1WoWQR0OBypTMbs/i4XrSaHKemcHWqp9bA5OjR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=Jp5hebDc; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="Jp5hebDc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=w9zP9J6663wEeYPf+juPQ3EAnD+ImwXNwIHFYIybSy0=; t=1762856277;
	x=1763288277; b=Jp5hebDc0l9W84AlUC8TKca+GxR+g7q14/rpR/XTm9VuSIqUonXyh0hVrv+mC
	Ttxa7YxOmPwjpu0h8brLR0DLOm2/GgnAt4+AFSYtw2ODh9u2y92k648W/IIGrbpBy+4+vEv4CBaPY
	ydkIteJdE4TkZfP1eLSFlMK1PSCJB+EZ/xKNY+Mwa2JCgtdCQhKjYeKJYjFXrrDh8RwDx6jzUFfpi
	08/8b1yw8wwhRhFOAI6D/tEMrzc5pOa7FJBlmr1iucE8NJJw1GthrCjyaXgWJknEOH2nOYrCw+F+v
	UqB8iBDdr3WxH56nT3I64/jpggCUm6R7e5ZtsHbPlBos9QneZA==;
Received: from [2a02:8108:8984:1d00:a0cf:1912:4be:477f]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	id 1vIlRc-003hyN-36;
	Tue, 11 Nov 2025 11:17:49 +0100
Message-ID: <50a08711-858b-4b37-a835-641c8d489006@leemhuis.info>
Date: Tue, 11 Nov 2025 11:17:48 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 145/849] bpftool: Add CET-aware symbol matching for
 x86_64 architectures
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Yuan Chen <chenyuan@kylinos.cn>,
 Daniel Borkmann <daniel@iogearbox.net>, Quentin Monnet <qmo@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20251111004536.460310036@linuxfoundation.org>
 <20251111004539.911440769@linuxfoundation.org>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 MEK4
In-Reply-To: <20251111004539.911440769@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1762856277;587b190d;
X-HE-SMSGID: 1vIlRc-003hyN-36

Below patch broke by rpm build for Fedora (based on Fedora's official
srpms) for me when building bpftool:

"""
link.c: In function ‘is_x86_ibt_enabled’:
link.c:288:37: error: array type has incomplete element type ‘struct kernel_config_option’
  288 |         struct kernel_config_option options[] = {
      |                                     ^~~~~~~
[...]
cc1: all warnings being treated as errors
make[2]: *** [Makefile:259: /builddir/build/BUILD/kernel-6.17.8-build/kernel-6.17.8-rc1/linux-6.17.8-0.rc1.300.vanilla.fc43.x86_64/tools/testing/selftests/bpf/tools/build/bpftool/link.o] Error 1
"""

Full log: 
https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/fedora-rc/fedora-43-x86_64/09786021-stablerc-fedorarc-releases/builder-live.log.gz

Reverting below change fixed things for me.

Haven't tried yet, but according from a quick search on lore as well
as what Sasha's AI says in
https://lore.kernel.org/all/20251009155752.773732-64-sashal@kernel.org/
it might also be possible to fix this by backporting 70f32a10ad423
("bpftool: Refactor kernel config reading into common helper")

Ciao, Thorsten

On 11/11/25 01:35, Greg Kroah-Hartman wrote:
> 6.17-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Yuan Chen <chenyuan@kylinos.cn>
> 
> [ Upstream commit 6417ca85305ecaffef13cf9063ac35da8fba8500 ]
> 
> Adjust symbol matching logic to account for Control-flow Enforcement
> Technology (CET) on x86_64 systems. CET prefixes functions with
> a 4-byte 'endbr' instruction, shifting the actual hook entry point to
> symbol + 4.
> 
> Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Quentin Monnet <qmo@kernel.org>
> Acked-by: Yonghong Song <yonghong.song@linux.dev>
> Acked-by: Jiri Olsa <jolsa@kernel.org>
> Link: https://lore.kernel.org/bpf/20250829061107.23905-3-chenyuan_fl@163.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/bpf/bpftool/link.c | 54 +++++++++++++++++++++++++++++++++++++---
>  1 file changed, 50 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
> index a773e05d5ade4..bdcd717b0348f 100644
> --- a/tools/bpf/bpftool/link.c
> +++ b/tools/bpf/bpftool/link.c
> @@ -282,11 +282,52 @@ get_addr_cookie_array(__u64 *addrs, __u64 *cookies, __u32 count)
>  	return data;
>  }
>  
> +static bool is_x86_ibt_enabled(void)
> +{
> +#if defined(__x86_64__)
> +	struct kernel_config_option options[] = {
> +		{ "CONFIG_X86_KERNEL_IBT", },
> +	};
> +	char *values[ARRAY_SIZE(options)] = { };
> +	bool ret;
> +
> +	if (read_kernel_config(options, ARRAY_SIZE(options), values, NULL))
> +		return false;
> +
> +	ret = !!values[0];
> +	free(values[0]);
> +	return ret;
> +#else
> +	return false;
> +#endif
> +}
> +
> +static bool
> +symbol_matches_target(__u64 sym_addr, __u64 target_addr, bool is_ibt_enabled)
> +{
> +	if (sym_addr == target_addr)
> +		return true;
> +
> +	/*
> +	 * On x86_64 architectures with CET (Control-flow Enforcement Technology),
> +	 * function entry points have a 4-byte 'endbr' instruction prefix.
> +	 * This causes kprobe hooks to target the address *after* 'endbr'
> +	 * (symbol address + 4), preserving the CET instruction.
> +	 * Here we check if the symbol address matches the hook target address
> +	 * minus 4, indicating a CET-enabled function entry point.
> +	 */
> +	if (is_ibt_enabled && sym_addr == target_addr - 4)
> +		return true;
> +
> +	return false;
> +}
> +
>  static void
>  show_kprobe_multi_json(struct bpf_link_info *info, json_writer_t *wtr)
>  {
>  	struct addr_cookie *data;
>  	__u32 i, j = 0;
> +	bool is_ibt_enabled;
>  
>  	jsonw_bool_field(json_wtr, "retprobe",
>  			 info->kprobe_multi.flags & BPF_F_KPROBE_MULTI_RETURN);
> @@ -306,11 +347,13 @@ show_kprobe_multi_json(struct bpf_link_info *info, json_writer_t *wtr)
>  	if (!dd.sym_count)
>  		goto error;
>  
> +	is_ibt_enabled = is_x86_ibt_enabled();
>  	for (i = 0; i < dd.sym_count; i++) {
> -		if (dd.sym_mapping[i].address != data[j].addr)
> +		if (!symbol_matches_target(dd.sym_mapping[i].address,
> +					   data[j].addr, is_ibt_enabled))
>  			continue;
>  		jsonw_start_object(json_wtr);
> -		jsonw_uint_field(json_wtr, "addr", dd.sym_mapping[i].address);
> +		jsonw_uint_field(json_wtr, "addr", (unsigned long)data[j].addr);
>  		jsonw_string_field(json_wtr, "func", dd.sym_mapping[i].name);
>  		/* Print null if it is vmlinux */
>  		if (dd.sym_mapping[i].module[0] == '\0') {
> @@ -719,6 +762,7 @@ static void show_kprobe_multi_plain(struct bpf_link_info *info)
>  {
>  	struct addr_cookie *data;
>  	__u32 i, j = 0;
> +	bool is_ibt_enabled;
>  
>  	if (!info->kprobe_multi.count)
>  		return;
> @@ -742,12 +786,14 @@ static void show_kprobe_multi_plain(struct bpf_link_info *info)
>  	if (!dd.sym_count)
>  		goto error;
>  
> +	is_ibt_enabled = is_x86_ibt_enabled();
>  	printf("\n\t%-16s %-16s %s", "addr", "cookie", "func [module]");
>  	for (i = 0; i < dd.sym_count; i++) {
> -		if (dd.sym_mapping[i].address != data[j].addr)
> +		if (!symbol_matches_target(dd.sym_mapping[i].address,
> +					   data[j].addr, is_ibt_enabled))
>  			continue;
>  		printf("\n\t%016lx %-16llx %s",
> -		       dd.sym_mapping[i].address, data[j].cookie, dd.sym_mapping[i].name);
> +		       (unsigned long)data[j].addr, data[j].cookie, dd.sym_mapping[i].name);
>  		if (dd.sym_mapping[i].module[0] != '\0')
>  			printf(" [%s]  ", dd.sym_mapping[i].module);
>  		else

