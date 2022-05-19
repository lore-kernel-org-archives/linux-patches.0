Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654A52904
	for <patches@lists.linux.dev>; Thu, 19 May 2022 17:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E440FC34100;
	Thu, 19 May 2022 17:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1652982498;
	bh=vLjIopQ/K98k8gpYLk/oPjiMCD9lvMAme/cdGzHW1Hk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KnNOMhlbM1GBTVdlLNeF2nhjakCHIzahZvc7P95GQRXy6LZnhxzaDKidDEo2F4zfe
	 HozAfii9GWZ1ONI5t78LLW5WSCfRIBYNEom42SHsLClPP4QXYJai524Hhca+i96DrX
	 8CIE606Jp/7qoK+p6/gkWRInE9slgum/3PuI7R8c84yTkTW/zSi1Zn+3hetDzLVwRM
	 N5Wwc69+iUIf0JQB9N9agFNzZlsD7e8mqF88AXCaBZsfPXDmQFXCDw0kYC87jL+4bT
	 Pm5Up4EGbCzGPU4+rVNDUwZtOQZJKW/xKP7mMWSrvqGTVtkgOEg6dAfVkAbjJwu417
	 oyzAGEYnS4+wA==
Message-ID: <92ba193f-f56a-ca67-925b-e9f839ae2357@kernel.org>
Date: Thu, 19 May 2022 20:48:12 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 5/2] dt-bindings: interconnect: Remove sc7180/sdx55 ipa
 compatibles
Content-Language: en-US
To: Alex Elder <elder@linaro.org>, Stephen Boyd <swboyd@chromium.org>,
 Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
 Doug Anderson <dianders@chromium.org>, Taniya Das <quic_tdas@quicinc.com>,
 Mike Tipton <quic_mdtipton@quicinc.com>
References: <20220412220033.1273607-1-swboyd@chromium.org>
 <20220415005828.1980055-1-swboyd@chromium.org>
 <20220415005828.1980055-3-swboyd@chromium.org>
 <a17603a8-f273-0dde-8e84-3c0616ff04aa@linaro.org>
From: Georgi Djakov <djakov@kernel.org>
In-Reply-To: <a17603a8-f273-0dde-8e84-3c0616ff04aa@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17.05.22 1:16, Alex Elder wrote:
> On 4/14/22 7:58 PM, Stephen Boyd wrote:
>> These interconnects are modeled as clks, not interconnects, therefore
>> remove the compatibles from the binding as they're unused.
>>
>> Cc: Alex Elder <elder@linaro.org>
>> Cc: Taniya Das <quic_tdas@quicinc.com>
>> Cc: Mike Tipton <quic_mdtipton@quicinc.com>
>> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>> ---
>>
>> I don't know who should apply this. Probably whoever takes the dtsi
>> patches, Bjorn?, because otherwise dt_bindings_check will fail.
> 
> I don't see this commit applied anywhere, though I
> might have missed it.  Is this for Bjorn, or Georgi,
> or someone else?

I merged it as Bjorn has already sent his pull request.

Thanks,
Georgi

> 
>                      -Alex
> 
>>   Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml 
>> b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
>> index 5a911be0c2ea..ab859150c7f7 100644
>> --- a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
>> +++ b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
>> @@ -31,7 +31,6 @@ properties:
>>         - qcom,sc7180-config-noc
>>         - qcom,sc7180-dc-noc
>>         - qcom,sc7180-gem-noc
>> -      - qcom,sc7180-ipa-virt
>>         - qcom,sc7180-mc-virt
>>         - qcom,sc7180-mmss-noc
>>         - qcom,sc7180-npu-noc
>> @@ -68,7 +67,6 @@ properties:
>>         - qcom,sdm845-mem-noc
>>         - qcom,sdm845-mmss-noc
>>         - qcom,sdm845-system-noc
>> -      - qcom,sdx55-ipa-virt
>>         - qcom,sdx55-mc-virt
>>         - qcom,sdx55-mem-noc
>>         - qcom,sdx55-system-noc
> 

