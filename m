Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0526E23CD
	for <patches@lists.linux.dev>; Fri, 22 Apr 2022 07:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDE5C385A4;
	Fri, 22 Apr 2022 07:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1650610889;
	bh=21Yl4xxhiWqKplYqfS+Y99XlgN55K+6oS3DyARdUs4o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JHv2sUfPT5E3Xt43uAbQdIR65LGFiab4UCBFrJovFH4Ar0GVM9ec8zwTyWUiHRXnY
	 xzGuwbcoLatbwti/gMFOM9cYHkdKayr9a2Gr30eliPJC3GmiLZwjp6/doleJ7Q+yfR
	 uDA30IHk5qsSoR0llts4WM1iqnxIhUODioI8bHTYK4eezUwf3N02q/cHI7oKAtJ1hZ
	 ikCBrNlyFD3lpL15W362ftXJ1oT6dyaCFrWMHjJyJ7FxlC0uihMHAIa+m5uCO8whgJ
	 t7uXmCT0wmBsYNwNL279LAq3zqmU3HDPOOSbdKhZNogr9wlgdjLAO8IBVqJyTJ2fQy
	 X0+8JcxzHvpWA==
Message-ID: <e54804ee-15f8-36a1-bbc5-9a218a4aec56@kernel.org>
Date: Fri, 22 Apr 2022 10:01:24 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 3/2] arm64: dts: qcom: sc7180: Remove ipa interconnect
 node
Content-Language: en-US
To: Bjorn Andersson <bjorn.andersson@linaro.org>,
 Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
 Doug Anderson <dianders@chromium.org>, Alex Elder <elder@linaro.org>,
 Taniya Das <quic_tdas@quicinc.com>, Mike Tipton <quic_mdtipton@quicinc.com>
References: <20220412220033.1273607-1-swboyd@chromium.org>
 <20220415005828.1980055-1-swboyd@chromium.org> <Yl92UkRwlQsd71mr@ripper>
From: Georgi Djakov <djakov@kernel.org>
In-Reply-To: <Yl92UkRwlQsd71mr@ripper>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.04.22 5:56, Bjorn Andersson wrote:
> On Thu 14 Apr 17:58 PDT 2022, Stephen Boyd wrote:
> 
>> This device node is unused now that we've removed the driver that
>> consumed it in the kernel. Drop the unused node to save some space.
>>
> 
> I'm expecting that merging patch 3 and 4 will work, but cause sync_state
> to not happen until the driver changes are merged.
> 
> Can you confirm my expectation? And perhaps confirm that it's fine for
> Georgi to pick the driver changes independently of the dts changes...

I have picked the driver changes, as the boot failure definitely needs to
be addressed. The sync-state might not happen until we have the DT changes
merged, as the framework is matching the count of probed drivers with the
count of providers in DT.

>> Cc: Alex Elder <elder@linaro.org>
>> Cc: Taniya Das <quic_tdas@quicinc.com>
>> Cc: Mike Tipton <quic_mdtipton@quicinc.com>
>> Cc: Georgi Djakov <djakov@kernel.org>
>> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Acked-by: Georgi Djakov <djakov@kernel.org>

Thanks,
Georgi

>> ---
>>   arch/arm64/boot/dts/qcom/sc7180.dtsi | 7 -------
>>   1 file changed, 7 deletions(-)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
>> index e1c46b80f14a..1ff96ef30e3f 100644
>> --- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
>> @@ -1421,13 +1421,6 @@ mmss_noc: interconnect@1740000 {
>>   			qcom,bcm-voters = <&apps_bcm_voter>;
>>   		};
>>   
>> -		ipa_virt: interconnect@1e00000 {
>> -			compatible = "qcom,sc7180-ipa-virt";
>> -			reg = <0 0x01e00000 0 0x1000>;
>> -			#interconnect-cells = <2>;
>> -			qcom,bcm-voters = <&apps_bcm_voter>;
>> -		};
>> -
>>   		ipa: ipa@1e40000 {
>>   			compatible = "qcom,sc7180-ipa";
>>   
>> -- 
>> https://chromeos.dev
>>

