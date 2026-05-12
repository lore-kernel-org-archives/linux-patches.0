Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E02B357CFF
	for <patches@lists.linux.dev>; Tue, 12 May 2026 20:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778618499; cv=none; b=C1+cd2K8DdpUis88ORkgRNNmT7rHe4vkhvRUTGKfUMCwlMmVfvnecEexcLW+vKoT0I4nrlyweiI1JPtG09y77WoK+lTKaRA/cLE+WcVLNCXo68Cya2X4mhuwVP65MUxlOAtmY7ftgYGctRO4nqoNV1bXraeYwxF2ltjPyMjkCrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778618499; c=relaxed/simple;
	bh=mZubmlekLduv78PkJ9UspZtMtIutTKl+OgZbzRPCyxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hlyMXTOLvic3AItf8F1kVLEpDb6PQT8ALyz9ngtIKn7W6MvrKQVdFi8lvOvOiJly9DDOAdXjXZfwwFNGnHOeq73nyhRKOz8z1NACxZTAtMqpzD+oc65jvyUkH6R1EZrGj+Qla7K0eu2zKlDze+rXBqUBJwZS8AczZYCmQ5jJRr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LennDqG+; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LennDqG+"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2ecf9e398f4so2279025eec.1
        for <patches@lists.linux.dev>; Tue, 12 May 2026 13:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778618497; x=1779223297; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CmByf/1D2iszo6zYS41ggp3d6e7T3VLwXedEo3RdCos=;
        b=LennDqG+V3tMpitd9FEIOuzMHi8eOy7VbudZuvir7oRUYFj8ZdJfHuUPXsu5F/mTNr
         R2pUHy9TQztgWLHzJFc+O6NbDttMhr6i80xHNgrOEMiLawSaBXgmYQwVNkAvmI5siZPx
         Rp3FQn0HA+DuQkFtMspK8CQcXVBW2pxwwf/F3r0moo0iLEo7Pef9EGfXE072FweBEsdn
         hannkbTyUM+xaGsEB6SJ8dFktd4phQyjRpa/ODby3+mVDjOBuDzkaEySjiulqTSjNUvl
         shJpgwdUnPuctxWDwCtQr0C41N4FYlGJZ4J20TGTdyqjVZMsCudXu1h3kLtkOGcAu0CU
         1Yeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778618497; x=1779223297;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CmByf/1D2iszo6zYS41ggp3d6e7T3VLwXedEo3RdCos=;
        b=Q6PsLCIVUYbjNkn+bP6LrS6v3HIWlioaQBBw9chtUkbfUesmk4b4U0RE9TBOAJWdsD
         Re4N8ud82s+iGjryq6sqrl0KT2hC6TWu0DTJdp0/Q3AUaxyQSzPOED82invnXSUScBwr
         jbAP9BRZZZHY25x2lBh3vfSOGUtq2EGU/V15AvwIvUE9tT4dNk2H0QEn6dj5kgpddRqc
         +tQV7Op6N1iJ0dXhvRYEe3p/b4MWX/XPaxyaqiPlQ+5CzFZEZW8wPzmOzxtOaSoMNspy
         3KlhLeROVzvE5pXgDzCAzjRJb50pFXkGjaCF4AxhXMDt40C01Cqf9PqfTMESrSEh6tL9
         VHwA==
X-Gm-Message-State: AOJu0Yxna8cHZuyVMTyZCcrEmtsSi2OvRr5zvX5DN21Z7ozSS7Exbasr
	9sJkZF3F4c5udT1/QOtHcfQzgcER0HrNlwP9oV0T6nBICJEQPTMAgV45g52eEl2Ykw==
X-Gm-Gg: Acq92OHMDBbGlpM2uypLTcEWkoe2yUDxTnwNWESVA7sNBdGUG+O2uvXnGmoQu0oTBUF
	uVzICuBT+6q2Qq9NEshq548NEMR3ofjRSfrnV+RghLuhG6ZLTC7gZrZF84CwKSSUsc48xvjmD1C
	7YQVflJMaT8dwb2UryQA6TCH3yhEdlnjmRNJ1dtZ1aNo3HAruPtlu/1J18aT9ZH6dm3Fwh0mxSg
	p3R3YBw1Jqe0S1D4cbcrtFjIuxI279SZUCIlN/j7wP66pruDSeej1rifeRbFscPxdQvUhK7SeuG
	uVcKCNDNwidK/mWO1QlpJONVqktKRL9kHLTxlOO4uSI5xO2So08jeZjPGutG3tjD0uVE6IyGs11
	AYJOWSJBPy9bjrYSP4yUrxDaFxxbCz8w3EYlbVZMD2d5sr1hU3guQOsaoxdq2Go0NTWX1req9ns
	DcA5zTyDPfs55u3SAhJfo/dwWv+ykEPHHl32CTUW3+bmYpBL4+BcRnpG+4XPNV8gko6XmVRotbS
	jZeyYeLnhryTScmB2T2jmkuDKyLkbBY8Cau
X-Received: by 2002:a05:7301:4902:b0:2e7:120:137b with SMTP id 5a478bee46e88-30114251733mr550634eec.0.1778618495944;
        Tue, 12 May 2026 13:41:35 -0700 (PDT)
Received: from ?IPV6:2a00:79e0:2e7c:8:839b:f905:79b7:838f? ([2a00:79e0:2e7c:8:839b:f905:79b7:838f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f8859eb034sm19502303eec.5.2026.05.12.13.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 13:41:35 -0700 (PDT)
Message-ID: <3f6a00ca-6020-455c-a7fc-f16b02112185@google.com>
Date: Tue, 12 May 2026 13:41:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 046/206] usb: typec: tcpm: reset internal port states
 on soft reset AMS
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, stable <stable@kernel.org>,
 Badhri Jagan Sridharan <badhri@google.com>,
 Heikki Krogerus <heikki.krogerus@linux.intel.com>
References: <20260512173932.810559588@linuxfoundation.org>
 <20260512173933.811124271@linuxfoundation.org>
Content-Language: en-US
From: Amit Sunil Dhamne <amitsd@google.com>
In-Reply-To: <20260512173933.811124271@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Greg,

On 5/12/26 10:38 AM, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
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
> @@ -5614,6 +5614,8 @@ static void run_state_machine(struct tcp
>   
>   	case VCONN_SWAP_ACCEPT:
>   		tcpm_pd_send_control(port, PD_CTRL_ACCEPT, TCPC_TX_SOP);
> +		port->vdm_sm_running = false;
> +		port->explicit_contract = false;


Please drop this patch from the queue. It was incorrectly applied to the 
VCONN_SWAP_ACCEPT case instead of the soft reset handling due to context 
fuzz. I will send a proper rebased backport for the 6.12 stable tree 
shortly.


Thanks,

Amit

>
