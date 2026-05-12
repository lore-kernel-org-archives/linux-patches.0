Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C243B2FD0
	for <patches@lists.linux.dev>; Tue, 12 May 2026 20:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778618647; cv=none; b=b4jk9toYkgS2iEYCyVXN8EFRsdRdJtetiAic2QrFAYJmS+h6oAotm9MDnYhfrfLzK/K8AL+WBD8dwH3Si0CkrytLeJJ8qryj38qesPSxQ+JL+aLTrIq++CKpQAJuTsDOPy394BCfRZXYruQ/JbBdwcRxshlafwhNRS6GN1IgWJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778618647; c=relaxed/simple;
	bh=QZbJexH7roQz9CTKUMXawNyoKnHRwN0ff8bY6zYjaJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IymHDx4eCMyFZlVSTTFgPfA1lD82JOIK09teHqqz88FKKexOtP2OApdSiWsZt4l/1Nu6qMx+ysG8Lg9iHcRb8XJmgba9GFFRgxvpFVWEQK8DMqgM6wZKij4iF/0WOMaKwHVbAwUUfuYYP1zCeXk88L+akP1XMM4e0KU/e2KH9is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AHnhlJUa; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AHnhlJUa"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-13317450f83so988048c88.0
        for <patches@lists.linux.dev>; Tue, 12 May 2026 13:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778618645; x=1779223445; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HOTVoVYKuXInZTCg9uFW7YHTqL8MrCZvgH2OHC0a8Po=;
        b=AHnhlJUadlcphVym3plr6rDPx49m+hNYewPxUTrBOD1hR/1gAta25ofRAQ7f4NCMoS
         LOrnFddru66Bk5+KXuCaySN9kHFUVzH5mAVrdJPe2v3LVHrSWn48N1sc4uQ0oT21sPLp
         NcBe2eOaUR89Q+JcXDhNC0pknYQny6Q/3cn9u40gdsuI8JjxUuCSE5rFScAPmY7wAmMH
         SF08TtLMNYROuCDPa+INllVXTWKD3m9h59kHm4uCr4wMCzVXgs7eHOIm//jC5rqD5o2+
         OX69c4Xkt1GaNDEJUx4+WJEcCw6JI7KjA/7+/2S7nSceao+ZljqBle1zjs3jlyhsP1oS
         upCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778618645; x=1779223445;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HOTVoVYKuXInZTCg9uFW7YHTqL8MrCZvgH2OHC0a8Po=;
        b=X204KlIGctGllvtTv8P57+tQw65SbAxVCJ/qlHbgA7+i0a0Y2sREDLL8T7r6iuiQc9
         02NmJsoKy2pwm+dwnK/ZN1EfXU6hcjCgRmrrI8Vr7A85iaSA6XTQJq2YEFp3j8Ys/GV5
         Qftx5kM5DjRjSpMBxIZTLtCiXoq6D0akY13KFHRTQCxMD+sL3xyK3DOX3C5BbaaSyrv6
         a4UbFHEBcfCWXl/xFOidavdnUgfg7gSvGm1hPCvMnc1WPbkq1//Hq+9P51A8HTNkWlH6
         TvgZpr9FXxjouzJHdZvK+EpDu8C4fg5otc2UXFqUR02plPMeOEwjmEPfDGCqjMRSUyNn
         DH9Q==
X-Gm-Message-State: AOJu0YzSJ6+O777wueu6e9s3bTysK/SqK5W5/HF2bApEIFSSdM2rF4CL
	nEWXIbgQn/ypo7inWIX+K1VK+8xejskwOCbBfJmhu4OsnzOWi3dLkU5atHpgSObiCw==
X-Gm-Gg: Acq92OFPVGO1YUDo+vSrOjcradIjVMby4ebrdEkjrW6SqvhXpssSdm+FNjUZaAaePox
	GoAcyTNTksE2pOXFhXB9P5OzuBc2bJ7BmDR6fltilV5novnH3dYU9lCjmvyj9O4oSZbswvqmblc
	vUmmYIzWflHQGBDoRVlzZK0Wi8R4roo5OhpwCgruCtwxnH0SiW3rPFz+ai0PbO4HDh3JrW8IzbA
	r0WuHu3O9OXoC5roG8anXkHwitKemBO6EFldt80J/pdEdMw642vx8ixQoQJeeiZTScecTwljjQ1
	XZakv/KVUUCSnsskpIUFBFfYJuqhePKmoQ7bVxUXc83bINiwf/JK1Ds8DoK4N7OJqTReNS+Qa8L
	pNyiqKhslzn0e2vksK+dgMm2hhdi61pVAitmh3qCiDTJIFO/IycULgryYlhePz6LWYL9+XSQFy7
	iNJyAFRnF8s1Vg5aLkUrGUvu3fLmVQQWQENAt8qFBDJ9L5ROdlzmH+L90NGmS7DwHc7UsRnCbUi
	esKWeafIsV7KXRhj4FlKiXQChRoCClEYwY4
X-Received: by 2002:a05:7022:6997:b0:12d:de3e:86a7 with SMTP id a92af1059eb24-13436bb1815mr297018c88.37.1778618644810;
        Tue, 12 May 2026 13:44:04 -0700 (PDT)
Received: from ?IPV6:2a00:79e0:2e7c:8:839b:f905:79b7:838f? ([2a00:79e0:2e7c:8:839b:f905:79b7:838f])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1327810ffb9sm27852209c88.2.2026.05.12.13.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 13:44:04 -0700 (PDT)
Message-ID: <7eb599f5-b5dc-43d5-be49-bf4997bee3dd@google.com>
Date: Tue, 12 May 2026 13:44:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 040/307] usb: typec: tcpm: reset internal port states
 on soft reset AMS
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, stable <stable@kernel.org>,
 Badhri Jagan Sridharan <badhri@google.com>,
 Heikki Krogerus <heikki.krogerus@linux.intel.com>
References: <20260512173940.117428952@linuxfoundation.org>
 <20260512173940.970675491@linuxfoundation.org>
Content-Language: en-US
From: Amit Sunil Dhamne <amitsd@google.com>
In-Reply-To: <20260512173940.970675491@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Greg,

On 5/12/26 10:37 AM, Greg Kroah-Hartman wrote:
> 7.0-stable review patch.  If anyone has any objections, please let me know.
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
> @@ -5741,6 +5741,8 @@ static void run_state_machine(struct tcp
>   
>   	case VCONN_SWAP_ACCEPT:
>   		tcpm_pd_send_control(port, PD_CTRL_ACCEPT, TCPC_TX_SOP);
> +		port->vdm_sm_running = false;
> +		port->explicit_contract = false;

Please drop this patch from the queue. It was incorrectly applied to the 
VCONN_SWAP_ACCEPT case instead of the soft reset handling due to context 
fuzz. I will send a proper rebased backport for the 7.0 stable tree shortly.


Thanks,

Amit

>
