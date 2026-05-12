Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DEA357CFF
	for <patches@lists.linux.dev>; Tue, 12 May 2026 20:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778618596; cv=none; b=dx9QnsAmCihm9Dk4/yuEkUdl7XMyTwnPSX26IlV2aa3ajXzKK7hnqgSJTRd3P6/KYVJI/lLzWw064HXrePZmqAWeNn9Nk9hUg/8V9OGrZWT3MAc4tShsA+ScqXTD0JsXsmS5vjV5eFsOpBcHCGG3BIEBgbF82MiAUYhez/ZiSnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778618596; c=relaxed/simple;
	bh=kg4NlVLFvpcet+/cj6Ad8BEvgEVUqQ5ua+TsGgeN3Rs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tUxZXf5n/AcYP2cxFGT09HHYkkv2txYDXxtuJ5XJx0EHiF+PXN3wxY2HuAanAYIVAqKKmuOXGH1hn4jmviGkxaaEtQdsGjMQULM/HfUbmWcmjgP6X/+sjVG/cYSkKqKBXNjD7BSGHbzzs3zFYwhLLtzPlWO00ewmWMb5EhvJS44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YDuvwxWK; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YDuvwxWK"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2f03d6cf77bso6788081eec.0
        for <patches@lists.linux.dev>; Tue, 12 May 2026 13:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778618595; x=1779223395; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C9lR0A9k7VO7RFKQ4e5f3LHHZHyRUjtt/Q+YXL4+DFc=;
        b=YDuvwxWKYvc4lNM2yuOBmlyV4WmE4UGgskshNLnIDzCwrQGSyzzXBgX6uMhMv+tfCi
         +oF/sJFz9SPRssBZzzqN1IYj2eOYqPmbsX69wdMKWUMw4RLyiZGqEIYgiR5WENvv9y3e
         724vm/DeAoli57jevtwRW1LNUgL6UlAijyeMr3gkFH+Qs6F/b0TLKkl4UmhNhWGNShzg
         cuZfVuDBl5CgEMA/fIiMEN9kwJH0FCX6eR7vYOLiHKuFNHKHnz+MSL955CcGuuEhdB+P
         5vpzedUW8uOMoSAMkPH3AG8a/vsf7pA2kdZVv5d9DiT63GOjBLsnNYNPMNQqVHq2bX1M
         tbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778618595; x=1779223395;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C9lR0A9k7VO7RFKQ4e5f3LHHZHyRUjtt/Q+YXL4+DFc=;
        b=pgBnIBxlsXno5MmrnvpWZuhFV1HWLznWc6vW9tIDxFJDKEhrPGPR/GOorq4C6fnq6A
         Wwju8LYzVZW6GTj5zHfovrFfcMfgr8tPcqOtsPmyIXsUe73wI+fqZA3/7rJ5M+5uE+nX
         2vCHrlvr2QzC5ZTJluMQlGnLN/Tb74/vhJseyBaa2CNOGlxXjQ5gNHofkOmeHcB4sQ7H
         rTTKuB12qjzN9lI640nJriJGfx1bjT9I3z7Ll4iOhTTS1HzesDvt0bHiBJh5TNAO6qWB
         Z1J6dqwF11GsyLfJvH90WrHpUL6QjcZgUff3JZ/6k8vJhr4hdvsteu/pN2GYOCfgN2eV
         +hzg==
X-Gm-Message-State: AOJu0Yzrq1cO/P1nodZ9CR6/XE+YfnVOleczSvJEiL6I+LO3eAq0Cb+D
	hgPiow1op5qANAmN/EcAZ2UAz+IXjO5L3708sySQBXL2LjjLk/M0NLXu9byOyA64og==
X-Gm-Gg: Acq92OFoF7qPe4SkGEe732ymsIveKZkBPK70fpWp/xUzwN98VY73lYqnzskADTeTVPP
	OIvfo8P7sqWv7ePIlynmP1wX2pdHsd1sf0tU05elUot+zwBUrJ1WXAYsbAXTPcs1pmSKXr/tqC4
	bmQYfS6ik+gO4KZwGyjKrkGVec3r4my4TbwsD93NoNrdXMruyOQuPw+y0AZl772o4nU+7CU3CYF
	nsg1683YQiWgwdZf/i4DpEYlsbjbXkK60SzMvFX+Nna6SSLgJREKwPiC6MuAsEioODRU0n5W1/q
	aTHXJLzp1LDuAlgFr22kKEKsZn9/b3+zRMymFDdwkbbsJcu124EjoY/PjgTHbxhQaulp1DjDRH8
	BM1/2uo1Q9ljBgdlqgPvqGwFv/iMyc4HN2mjqdWX+pGTFHBUnKwwp8H7HWwma6N56/q7NDTsIHc
	99LY7bDB0IV8sUtcUpmuIjgsbd05vn4RUlJlaJ5yhEWTejGnETIRFYlD3Us6zp84TKXu1tixifn
	8K5yv42860Zm7F9O6KBIJy+5hytm3QMbP2y
X-Received: by 2002:a05:7301:6783:b0:2de:aafb:feff with SMTP id 5a478bee46e88-30117c73cddmr372091eec.2.1778618593919;
        Tue, 12 May 2026 13:43:13 -0700 (PDT)
Received: from ?IPV6:2a00:79e0:2e7c:8:839b:f905:79b7:838f? ([2a00:79e0:2e7c:8:839b:f905:79b7:838f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f8859eafc2sm24437991eec.4.2026.05.12.13.43.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 13:43:13 -0700 (PDT)
Message-ID: <4b812fea-fd3f-45e0-a377-3ded43fba700@google.com>
Date: Tue, 12 May 2026 13:43:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 043/270] usb: typec: tcpm: reset internal port states
 on soft reset AMS
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, stable <stable@kernel.org>,
 Badhri Jagan Sridharan <badhri@google.com>,
 Heikki Krogerus <heikki.krogerus@linux.intel.com>
References: <20260512173938.452574370@linuxfoundation.org>
 <20260512173939.360401506@linuxfoundation.org>
Content-Language: en-US
From: Amit Sunil Dhamne <amitsd@google.com>
In-Reply-To: <20260512173939.360401506@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Greg,

On 5/12/26 10:37 AM, Greg Kroah-Hartman wrote:
> 6.18-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Amit Sunil Dhamne <amitsd@google.com>
>
> commit 2909f0d4994fb4306bf116df5ccee797791fce2c upstream.
>
> Reset internal port states (such as vdm_sm_running and
> explicit_contract) on soft reset AMS as the port needs to negotiate a
> new contract. The consequence of leaving the states in as-is cond are as
> follows:
>    * port is in SRC power role and an explicit contract is negotiated
>      with the port partner (in sink role)
>    * port partner sends a Soft Reset AMS while VDM State Machine is
>      running
>    * port accepts the Soft Reset request and the port advertises src caps
>    * port partner sends a Request message but since the explicit_contract
>      and vdm_sm_running are true from previous negotiation, the port ends
>      up sending Soft Reset instead of Accept msg.
>
> Stub Log:
> [  203.653942] AMS DISCOVER_IDENTITY start
> [  203.653947] PD TX, header: 0x176f
> [  203.655901] PD TX complete, status: 0
> [  203.657470] PD RX, header: 0x124f [1]
> [  203.657477] Rx VDM cmd 0xff008081 type 2 cmd 1 len 1
> [  203.657482] AMS DISCOVER_IDENTITY finished
> [  203.657484] cc:=4
> [  204.155698] PD RX, header: 0x144f [1]
> [  204.155718] Rx VDM cmd 0xeeee8001 type 0 cmd 1 len 1
> [  204.155741] PD TX, header: 0x196f
> [  204.157622] PD TX complete, status: 0
> [  204.160060] PD RX, header: 0x4d [1]
> [  204.160066] state change SRC_READY -> SOFT_RESET [rev2 SOFT_RESET_AMS]
> [  204.160076] PD TX, header: 0x163
> [  204.162486] PD TX complete, status: 0
> [  204.162832] AMS SOFT_RESET_AMS finished
> [  204.162840] cc:=4
> [  204.162891] AMS POWER_NEGOTIATION start
> [  204.162896] state change SOFT_RESET -> AMS_START [rev2 POWER_NEGOTIATION]
> [  204.162908] state change AMS_START -> SRC_SEND_CAPABILITIES [rev2 POWER_NEGOTIATION]
> [  204.162913] PD TX, header: 0x1361
> [  204.165529] PD TX complete, status: 0
> [  204.165571] pending state change SRC_SEND_CAPABILITIES -> SRC_SEND_CAPABILITIES_TIMEOUT @ 60 ms [rev2 POWER_NEGOTIATION]
> [  204.166996] PD RX, header: 0x1242 [1]
> [  204.167009] state change SRC_SEND_CAPABILITIES -> SRC_SOFT_RESET_WAIT_SNK_TX [rev2 POWER_NEGOTIATION]
> [  204.167019] AMS POWER_NEGOTIATION finished
> [  204.167020] cc:=4
> [  204.167083] AMS SOFT_RESET_AMS start
> [  204.167086] state change SRC_SOFT_RESET_WAIT_SNK_TX -> SOFT_RESET_SEND [rev2 SOFT_RESET_AMS]
> [  204.167092] PD TX, header: 0x16d
> [  204.168824] PD TX complete, status: 0
> [  204.168854] pending state change SOFT_RESET_SEND -> HARD_RESET_SEND @ 60 ms [rev2 SOFT_RESET_AMS]
> [  204.171876] PD RX, header: 0x43 [1]
> [  204.171879] AMS SOFT_RESET_AMS finished
>
> This causes COMMON.PROC.PD.11.2 check failure for
> TEST.PD.VDM.SRC.2_Rev2Src test on the PD compliance tester.
>
> Signed-off-by: Amit Sunil Dhamne <amitsd@google.com>
> Fixes: 8d3a0578ad1a ("usb: typec: tcpm: Respond Wait if VDM state machine is running")
> Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
> Cc: stable <stable@kernel.org>
> Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
> Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Link: https://patch.msgid.link/20260414-fix-soft-reset-v1-1-01d7cb9764e2@google.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/usb/typec/tcpm/tcpm.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -5728,6 +5728,8 @@ static void run_state_machine(struct tcp
>   
>   	case VCONN_SWAP_ACCEPT:
>   		tcpm_pd_send_control(port, PD_CTRL_ACCEPT, TCPC_TX_SOP);
> +		port->vdm_sm_running = false;
> +		port->explicit_contract = false;

Please drop this patch from the queue. It was incorrectly applied to the 
VCONN_SWAP_ACCEPT case instead of the soft reset handling due to context 
fuzz. I will send a proper rebased backport for the 6.18 stable tree 
shortly.


Thanks,

Amit

>
