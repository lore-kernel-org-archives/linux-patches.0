Received: from mail-ed1-f67.google.com (mail-ed1-f67.google.com [209.85.208.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C487F23C4FB
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 07:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749023845; cv=none; b=AqPxcp631igyZsTmFUib7tNMEoDekTMtqJ97hvuWVuM++rESThKIrS3sT8uor8SypAVpFoSWgjZLUpDISfIwRG1IeylMYxu3L9RdPDCuVnzQDb9A9EVceJ+n2hcVnk6Ir1a1V61VTtfH7AT0MskizErGpaeVJA3P82oEKkNtCSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749023845; c=relaxed/simple;
	bh=L46qMq+D+EBrCxQHPK4bgVL7HHhc0eQbNNC3ccWBnwg=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XBNLGCtDCa2pllwybo9lKQaU8nAcMz3Duvm9+Fk7scVoNQNeIeNwYl0jXtRqbwJYNMSgLqlyIzw1Jyrqla0W9p+uSPT90r0q4x1Bu2cxLePGbwgQYcw//XLJoft8w2hrREaSev+9zybNZOCYivwZ8ZN/QO0ttGKMuCscn5jAqy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f67.google.com with SMTP id 4fb4d7f45d1cf-604f5691bceso11812885a12.0
        for <patches@lists.linux.dev>; Wed, 04 Jun 2025 00:57:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749023842; x=1749628642;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:cc:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XHNpHqmGP7U60UZaiDJu6Szs2+L4LA+55N7lpFChv+o=;
        b=Vzy/yKyrURVkxFBrQi8+avCIaBfT+LJ0pwdJfl+K7e9F7gA5LdT2eukeZwk1pHeVbk
         M1F1NqBDEWRtH6qt/4pLL4GyzOoFtzq82byIee+rVL5G0IVi44w2vS6dvQ4/Orl4k/mj
         xRfPjOl5VmlAQpFMCUnsk5IFcLteH8NFzfd4IgImVbflvxDWDV6sTuZszPdON7IZ/EKb
         0gHfREtBIGcrPGg/e68TDp1jQu8uh7kHTCUTxMqlilz/L9l2ubS+XMDpJrd8wJRPja8i
         AJiJYanwFE5OqPfOe2GIJjfTdMgEkWN+YbigKG568wLvWlqpVsEdVzkw7zCI54TFqzKh
         3ymA==
X-Forwarded-Encrypted: i=1; AJvYcCVkJzLvkkyzPJrPsUXxqZp+CbyTqDIVMNbLufGSX5frExunSPEsznV5nHWcXqUYTy5K38dJGIqM@lists.linux.dev
X-Gm-Message-State: AOJu0YzoCa7euWD7lFohBeR87KiM72JGf7FFbsT+6LCcRRA+H1kaQax5
	4dTVSJFNOLltvr+YixRbMB1IC54iyUf1eD4A1C9lSHjsRw0HONyYW2yp
X-Gm-Gg: ASbGncs7IypBoXpLAiN5QV97s4AUlI97EzzlsHxxTsqNG+UTeowrPsuoRIPuINYpHiR
	UgfxjA4mH/Dad0s0GmtNz/ytREtLejV/4Mny9zV8rU/DX4FTmPLmYHo7hNuAnWI7j0e2PnLeu8m
	KF6k1cpQ8wSiemZJ1PJdtdZimaqYIjpogaa7Etyp03qgfZxmoj8G1oQRUuPGaru1F3E9x3Ril2m
	7Xs6nkeNMqtEAVnilbmqd67HIkioo4d68bYS92FWuAF5PftR5105KzuKn/8A0M4fQSj5wtap/Ch
	92f4ErlmE2EpTNTM3MXAIQkSJIF5opEHiWsiWVikEXb+FdQB6f01q2jHfFaLxJtf2Pq0oF6Lfma
	1VhkIoQ+IW9gXzBbrKw==
X-Google-Smtp-Source: AGHT+IEhk37rbANfdiENcZ1PpPl1Pqx01O4xsScKv4/4eC4FM1JHHLRgR7RXjlq8dDa+pO7/QsIFgQ==
X-Received: by 2002:a17:907:9625:b0:ad5:372d:87e3 with SMTP id a640c23a62f3a-addf8d5f86fmr160880766b.27.1749023841666;
        Wed, 04 Jun 2025 00:57:21 -0700 (PDT)
Received: from [192.168.88.252] (78-80-16-19.customers.tmcz.cz. [78.80.16.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad6ac52sm1066859466b.170.2025.06.04.00.57.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 00:57:21 -0700 (PDT)
Message-ID: <38ef1815-5bc1-4391-b487-05a18e84c94e@ovn.org>
Date: Wed, 4 Jun 2025 09:57:20 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: i.maximets@ovn.org, Eelco Chaudron <echaudro@redhat.com>,
 Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 aconole@redhat.com, netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH AUTOSEL 6.15 044/118] openvswitch: Stricter validation for
 the userspace action
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
References: <20250604005049.4147522-1-sashal@kernel.org>
 <20250604005049.4147522-44-sashal@kernel.org>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <20250604005049.4147522-44-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/4/25 2:49 AM, Sasha Levin wrote:
> From: Eelco Chaudron <echaudro@redhat.com>
> 
> [ Upstream commit 88906f55954131ed2d3974e044b7fb48129b86ae ]
> 
> This change enhances the robustness of validate_userspace() by ensuring
> that all Netlink attributes are fully contained within the parent
> attribute. The previous use of nla_parse_nested_deprecated() could
> silently skip trailing or malformed attributes, as it stops parsing at
> the first invalid entry.
> 
> By switching to nla_parse_deprecated_strict(), we make sure only fully
> validated attributes are copied for later use.
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> Reviewed-by: Simon Horman <horms@kernel.org>
> Acked-by: Ilya Maximets <i.maximets@ovn.org>
> Link: https://patch.msgid.link/67eb414e2d250e8408bb8afeb982deca2ff2b10b.1747037304.git.echaudro@redhat.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> **YES** This commit should be backported to stable kernel trees. ##
> Analysis **Commit Overview:** The commit changes `validate_userspace()`
> function in `net/openvswitch/flow_netlink.c` by replacing
> `nla_parse_nested_deprecated()` with `nla_parse_deprecated_strict()` to
> ensure stricter validation of Netlink attributes for the userspace
> action. **Specific Code Changes:** The key change is on lines 3052-3054:
> ```c // Before: error = nla_parse_nested_deprecated(a,
> OVS_USERSPACE_ATTR_MAX, attr, userspace_policy, NULL); // After: error =
> nla_parse_deprecated_strict(a, OVS_USERSPACE_ATTR_MAX, nla_data(attr),
> nla_len(attr), userspace_policy, NULL); ``` **Why This Should Be
> Backported:** 1. **Security Enhancement:** This commit addresses a
> parsing vulnerability where malformed attributes could be silently
> ignored. The original `nla_parse_nested_deprecated()` stops parsing at
> the first invalid entry, potentially allowing trailing malformed data to
> bypass validation. 2. **Robustness Fix:** The change ensures all netlink
> attributes are fully contained within the parent attribute bounds,
> preventing potential buffer over-reads or under-reads that could lead to
> security issues. 3. **Pattern Consistency:** Looking at the git blame
> output (lines 3085-3087), we can see that
> `nla_parse_deprecated_strict()` was already introduced in 2019 by commit
> 8cb081746c031 and is used elsewhere in the same file for similar
> validation (e.g., `validate_and_copy_check_pkt_len()` function). 4.
> **Low Risk:** This is a small, contained change that only affects input
> validation - it doesn't change functionality or introduce new features.
> The change is defensive and follows existing patterns in the codebase.
> 5. **Similar Precedent:** This commit is very similar to the validated
> "Similar Commit #2" which was marked for backporting (status: YES). That
> commit also dealt with netlink attribute validation safety in
> openvswitch (`validate_set()` function) and was considered suitable for
> stable trees. 6. **Critical Subsystem:** Open vSwitch is a critical
> networking component used in virtualization and container environments.
> Input validation issues in this subsystem could potentially be exploited
> for privilege escalation or denial of service. 7. **Clear Intent:** The
> commit message explicitly states this "enhances robustness" and ensures
> "only fully validated attributes are copied for later use," indicating
> this is a defensive security improvement. **Risk Assessment:** - Very
> low regression risk - No API changes - Only affects error handling paths
> - Follows established validation patterns in the same codebase This
> commit fits perfectly into the stable tree criteria: it's an important
> security/robustness fix, has minimal risk of regression, is well-
> contained, and addresses a clear validation vulnerability in a critical
> kernel subsystem.

This change is one of two patches created for userspace action.  With an
intentional split - one for net and one for net-next  First one was the
actual fix that addressed a real bug:
  6beb6835c1fb ("openvswitch: Fix unsafe attribute parsing in output_userspace()")
  https://lore.kernel.org/netdev/0bd65949df61591d9171c0dc13e42cea8941da10.1746541734.git.echaudro@redhat.com/

This second change (this patch) was intended for -next only as it doesn't
fix any real issue, but affects uAPI, and so should NOT be backported.

Best regards, Ilya Maximets.

> 
>  net/openvswitch/flow_netlink.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> index 518be23e48ea9..ad64bb9ab5e25 100644
> --- a/net/openvswitch/flow_netlink.c
> +++ b/net/openvswitch/flow_netlink.c
> @@ -3049,7 +3049,8 @@ static int validate_userspace(const struct nlattr *attr)
>  	struct nlattr *a[OVS_USERSPACE_ATTR_MAX + 1];
>  	int error;
>  
> -	error = nla_parse_nested_deprecated(a, OVS_USERSPACE_ATTR_MAX, attr,
> +	error = nla_parse_deprecated_strict(a, OVS_USERSPACE_ATTR_MAX,
> +					    nla_data(attr), nla_len(attr),
>  					    userspace_policy, NULL);
>  	if (error)
>  		return error;

