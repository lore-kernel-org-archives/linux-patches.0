Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.154.239.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795779016;
	b=Ey3kIE31xglH/zdA2hr//gBVwsL0TyG/7r6cJlZkbN3Jr7/cG4BipmUwv9qX7qEc1v8s
	 fblusC7pF8FfmNH1gk37pYxHF2aVoCJapl/FTqst3e3TR2c1PLBEdJs/MpRyqG5TQWphi
	 2fFCnfxrBKGsNNZfjgS0UJOzL5IX9GVbdEHyOPvRQEjWDy4xFc75FKD88sjinvomzjIPB
	 i7qcUMMxF/kjMv7gDrTpwEu0kLq0/kLNmLokYRl2FBLnEpUUDspgUqopJu2bZa2xr4W/M
	 1LBgpzT+HHUzHESDHniQILPeMK9YXFpnbdmceH5nd05SH9IZvw2WnehLWfX6+iI/EMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795779016;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=gereHGF8JJoi5rZwMI0qXVJBdf0r6OrNt29PH2qqFg4=;
	b=O8lzIwx0UiyFK5Y2yTVd7vzflxaZAwThdvNoeH670jDufRMxKYKDLnm/hZL1QuywTWWX
	 yug0nuD5pw6QxURRjJT/o22U2HvFjx/vTNqcqapuc9g2+4iOa7u1yI7G8fwqKV7IXbnqt
	 z1ObYMeBg3y+dh1oh2teI9ABObkOmldqg3aS//fCljU45siRLII/jD2VCLvE4KdoVlmSO
	 VGlkYZZt40kif3ioUbvEKgSTA2ff++MQO8NndxZxjleEvebkgs1JIrd8yeQxbK7tBdgR7
	 +ki31ROS8DoRXq1HFCqXEQF5VS7m0tIpV7sUKAX7zAxqBHCW1jdXJ5dKxnE20d3iCww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex-team.ru;
	spf=pass smtp.mailfrom=yandex-team.ru;
	dkim=pass header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b="0ijb7/A/";
	arc=none smtp.remote-ip=178.154.239.200
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CACE606A324
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 11:30:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CACE606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.a=rsa-sha256 header.s=default header.b=0ijb7/A/
Received: from mail-nwsmtp-smtp-corp-main-68 (mail-nwsmtp-smtp-corp-main-68.yp-c.yandex.net)
	by forwardcorp1d.mail.yandex.net (postfix) with ESMTPS id 599D980739;
	Fri, 27 Nov 2026 14:30:05 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:31::1:1e]
	by mail-nwsmtp-smtp-corp-main-68 with ESMTPSA id 3UhaXO9WRSw0-8IfutJsT;
	Fri, 27 Nov 2026 14:30:04 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1795779004;
	bh=gereHGF8JJoi5rZwMI0qXVJBdf0r6OrNt29PH2qqFg4=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=0ijb7/A/qzL8ed5dTeWBa1c7LWSb/qewsouh6/Hriauyj0Y/9ubg8Mi4080ORytrZ
	 g1pIUKsOjTEUbjliib00vk72tSnQKmVYtYqw0doVluX10QXfGw4i/1y5nVxsExBbZ1
	 hQ6vMo25/LserW6gOpfgRyh/JeLgk0yLK9dwTSyM=
Authentication-Results: mail-nwsmtp-smtp-corp-main-68; dkim=pass header.i=@yandex-team.ru
Message-ID: <1e035d4c-3eb0-402c-afaf-ff0affb9a5e6@yandex-team.ru>
Date: Fri, 27 Nov 2026 14:30:03 +0300
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 2333/3318] bpftool: Add support to display
 uprobe_multi links
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Jiri Olsa <jolsa@kernel.org>,
 Andrii Nakryiko <andrii@kernel.org>, Quentin Monnet <quentin@isovalent.com>,
 Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20261118150313.527275416@linuxfoundation.org>
 <20261118150431.639921252@linuxfoundation.org>
Content-Language: en-US
From: Maksim Davydov <davydov-max@yandex-team.ru>
In-Reply-To: <20261118150431.639921252@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi!
It seems that necessary e56fdbfb06e2 ("bpf: Add link_info support for
uprobe multi link") was omitted from v6.6.163 because a7795698f8b6
("bpftool: Add support to display uprobe_multi links") depends on it. I
encountered a build error while compiling bpftool.

The build error:
link.c:307:11: error: ‘struct bpf_link_info’ has no member named
‘uprobe_multi’; did you mean ‘kprobe_multi’?

On 11/18/26 17:49, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jiri Olsa <jolsa@kernel.org>
> 
> [ Upstream commit a7795698f8b6c48283fa4334eb313bc1350b2864 ]
> 
> Adding support to display details for uprobe_multi links,
> both plain:
> 
>   # bpftool link -p
>   ...
>   24: uprobe_multi  prog 126
>           uprobe.multi  path /home/jolsa/bpf/test_progs  func_cnt 3  pid 4143
>           offset             ref_ctr_offset     cookies
>           0xd1f88            0xf5d5a8           0xdead
>           0xd1f8f            0xf5d5aa           0xbeef
>           0xd1f96            0xf5d5ac           0xcafe
> 
> and json:
> 
>   # bpftool link -p
>   [{
>   ...
>       },{
>           "id": 24,
>           "type": "uprobe_multi",
>           "prog_id": 126,
>           "retprobe": false,
>           "path": "/home/jolsa/bpf/test_progs",
>           "func_cnt": 3,
>           "pid": 4143,
>           "funcs": [{
>                   "offset": 860040,
>                   "ref_ctr_offset": 16111016,
>                   "cookie": 57005
>               },{
>                   "offset": 860047,
>                   "ref_ctr_offset": 16111018,
>                   "cookie": 48879
>               },{
>                   "offset": 860054,
>                   "ref_ctr_offset": 16111020,
>                   "cookie": 51966
>               }
>           ]
>       }
>   ]
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>
> Acked-by: Song Liu <song@kernel.org>
> Link: https://lore.kernel.org/bpf/20231125193130.834322-7-jolsa@kernel.org
> Stable-dep-of: dbf8cef936c7 ("bpftool: Fix CPU IDs in per-CPU map output")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/bpf/bpftool/link.c | 105 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 103 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
> index 2e5c231e08ac7..00ecc67b54712 100644
> --- a/tools/bpf/bpftool/link.c
> +++ b/tools/bpf/bpftool/link.c
> @@ -293,6 +293,37 @@ show_kprobe_multi_json(struct bpf_link_info *info, json_writer_t *wtr)
>  	jsonw_end_array(json_wtr);
>  }
>  
> +static __u64 *u64_to_arr(__u64 val)
> +{
> +	return (__u64 *) u64_to_ptr(val);
> +}
> +
> +static void
> +show_uprobe_multi_json(struct bpf_link_info *info, json_writer_t *wtr)
> +{
> +	__u32 i;
> +
> +	jsonw_bool_field(json_wtr, "retprobe",
> +			 info->uprobe_multi.flags & BPF_F_UPROBE_MULTI_RETURN);
> +	jsonw_string_field(json_wtr, "path", (char *) u64_to_ptr(info->uprobe_multi.path));
> +	jsonw_uint_field(json_wtr, "func_cnt", info->uprobe_multi.count);
> +	jsonw_int_field(json_wtr, "pid", (int) info->uprobe_multi.pid);
> +	jsonw_name(json_wtr, "funcs");
> +	jsonw_start_array(json_wtr);
> +
> +	for (i = 0; i < info->uprobe_multi.count; i++) {
> +		jsonw_start_object(json_wtr);
> +		jsonw_uint_field(json_wtr, "offset",
> +				 u64_to_arr(info->uprobe_multi.offsets)[i]);
> +		jsonw_uint_field(json_wtr, "ref_ctr_offset",
> +				 u64_to_arr(info->uprobe_multi.ref_ctr_offsets)[i]);
> +		jsonw_uint_field(json_wtr, "cookie",
> +				 u64_to_arr(info->uprobe_multi.cookies)[i]);
> +		jsonw_end_object(json_wtr);
> +	}
> +	jsonw_end_array(json_wtr);
> +}
> +
>  static void
>  show_perf_event_kprobe_json(struct bpf_link_info *info, json_writer_t *wtr)
>  {
> @@ -459,6 +490,9 @@ static int show_link_close_json(int fd, struct bpf_link_info *info)
>  	case BPF_LINK_TYPE_KPROBE_MULTI:
>  		show_kprobe_multi_json(info, json_wtr);
>  		break;
> +	case BPF_LINK_TYPE_UPROBE_MULTI:
> +		show_uprobe_multi_json(info, json_wtr);
> +		break;
>  	case BPF_LINK_TYPE_PERF_EVENT:
>  		switch (info->perf_event.type) {
>  		case BPF_PERF_EVENT_EVENT:
> @@ -666,6 +700,33 @@ static void show_kprobe_multi_plain(struct bpf_link_info *info)
>  	}
>  }
>  
> +static void show_uprobe_multi_plain(struct bpf_link_info *info)
> +{
> +	__u32 i;
> +
> +	if (!info->uprobe_multi.count)
> +		return;
> +
> +	if (info->uprobe_multi.flags & BPF_F_UPROBE_MULTI_RETURN)
> +		printf("\n\turetprobe.multi  ");
> +	else
> +		printf("\n\tuprobe.multi  ");
> +
> +	printf("path %s  ", (char *) u64_to_ptr(info->uprobe_multi.path));
> +	printf("func_cnt %u  ", info->uprobe_multi.count);
> +
> +	if (info->uprobe_multi.pid)
> +		printf("pid %d  ", info->uprobe_multi.pid);
> +
> +	printf("\n\t%-16s   %-16s   %-16s", "offset", "ref_ctr_offset", "cookies");
> +	for (i = 0; i < info->uprobe_multi.count; i++) {
> +		printf("\n\t0x%-16llx 0x%-16llx 0x%-16llx",
> +			u64_to_arr(info->uprobe_multi.offsets)[i],
> +			u64_to_arr(info->uprobe_multi.ref_ctr_offsets)[i],
> +			u64_to_arr(info->uprobe_multi.cookies)[i]);
> +	}
> +}
> +
>  static void show_perf_event_kprobe_plain(struct bpf_link_info *info)
>  {
>  	const char *buf;
> @@ -792,6 +853,9 @@ static int show_link_close_plain(int fd, struct bpf_link_info *info)
>  	case BPF_LINK_TYPE_KPROBE_MULTI:
>  		show_kprobe_multi_plain(info);
>  		break;
> +	case BPF_LINK_TYPE_UPROBE_MULTI:
> +		show_uprobe_multi_plain(info);
> +		break;
>  	case BPF_LINK_TYPE_PERF_EVENT:
>  		switch (info->perf_event.type) {
>  		case BPF_PERF_EVENT_EVENT:
> @@ -831,8 +895,10 @@ static int show_link_close_plain(int fd, struct bpf_link_info *info)
>  
>  static int do_show_link(int fd)
>  {
> +	__u64 *ref_ctr_offsets = NULL, *offsets = NULL, *cookies = NULL;
>  	struct bpf_link_info info;
>  	__u32 len = sizeof(info);
> +	char path_buf[PATH_MAX];
>  	__u64 *addrs = NULL;
>  	char buf[PATH_MAX];
>  	int count;
> @@ -874,6 +940,39 @@ static int do_show_link(int fd)
>  			goto again;
>  		}
>  	}
> +	if (info.type == BPF_LINK_TYPE_UPROBE_MULTI &&
> +	    !info.uprobe_multi.offsets) {
> +		count = info.uprobe_multi.count;
> +		if (count) {
> +			offsets = calloc(count, sizeof(__u64));
> +			if (!offsets) {
> +				p_err("mem alloc failed");
> +				close(fd);
> +				return -ENOMEM;
> +			}
> +			info.uprobe_multi.offsets = ptr_to_u64(offsets);
> +			ref_ctr_offsets = calloc(count, sizeof(__u64));
> +			if (!ref_ctr_offsets) {
> +				p_err("mem alloc failed");
> +				free(offsets);
> +				close(fd);
> +				return -ENOMEM;
> +			}
> +			info.uprobe_multi.ref_ctr_offsets = ptr_to_u64(ref_ctr_offsets);
> +			cookies = calloc(count, sizeof(__u64));
> +			if (!cookies) {
> +				p_err("mem alloc failed");
> +				free(cookies);
> +				free(offsets);
> +				close(fd);
> +				return -ENOMEM;
> +			}
> +			info.uprobe_multi.cookies = ptr_to_u64(cookies);
> +			info.uprobe_multi.path = ptr_to_u64(path_buf);
> +			info.uprobe_multi.path_size = sizeof(path_buf);
> +			goto again;
> +		}
> +	}
>  	if (info.type == BPF_LINK_TYPE_PERF_EVENT) {
>  		switch (info.perf_event.type) {
>  		case BPF_PERF_EVENT_TRACEPOINT:
> @@ -909,8 +1008,10 @@ static int do_show_link(int fd)
>  	else
>  		show_link_close_plain(fd, &info);
>  
> -	if (addrs)
> -		free(addrs);
> +	free(ref_ctr_offsets);
> +	free(cookies);
> +	free(offsets);
> +	free(addrs);
>  	close(fd);
>  	return 0;
>  }

-- 
Best regards,
Maksim Davydov

