Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050972103
	for <patches@lists.linux.dev>; Sun, 22 May 2022 07:57:21 +0000 (UTC)
Received: by mail-lf1-f41.google.com with SMTP id w14so20734187lfl.13
        for <patches@lists.linux.dev>; Sun, 22 May 2022 00:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=35twz+aQUEzDFOmoqnq8gogZgXLJYGoPb8UN0JxVJI8=;
        b=FVkwAOZftQuTVX9zZdVnE54N6t8U/IbkB8NmNNoGm6LFdUoBAlNeBfTWLHDoYIJKgR
         9ImS8aoO6R9fwBv4DvEdkF7TPTCv+uVDmbGr1qNMS2ordDlKIkx+EX9pXRLSWvI3rn1V
         yeK7i/ycxCPb76AhYs++x8eT4kQ0mE5XvKw57WqSbnkD52lSUNfOrFeAJzzMLnwRvWib
         oVHPTnpxxgv8rxPnBxp3AC0SBEjpu0YBzwhRoKhyTwoaUqBxSLWo9os3W5Z1buRHSGvv
         QOx5sa40UztIGc1/1d8bl9n1I9PpmiAdWoNqfRj7jrPqKZfoeGqhw6jGvZJ2OcWMWOpq
         TgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=35twz+aQUEzDFOmoqnq8gogZgXLJYGoPb8UN0JxVJI8=;
        b=nxC/U5W0a3JP0kZx/VAlx9WuGJSElen7z4cZRDWvEle8ZtU3Ka3VJEPx66S8MJzIeK
         H6Fkui92ulB35cuJfDP8n04BkHR5hqg5sxNQ1Z5vhy6F2lrzaM8REudAaHtWOPqkf3SE
         qOYQ2s6uUfItfCZ8GMBHyDCu/CYDWo9d04+MJ+2Y7yPFcsNtW2yFI2Lqky01/DEvtLdv
         N550diPw5ttWJpkKNSo99CVVh28W+E5MGKmGR5+m1BU9lJAy5y7Pt/W5Xct/pr4x4ykc
         Jk5HPQcjpKHPYkDU69XVZZfhdWBTVOa2uK7geN9rdhpuBv5mE2pcWt0xAAB9UZbRNNj6
         UQjw==
X-Gm-Message-State: AOAM532cVV3aBQVrQt7uXZVhLrNx5pQDFMFAFes04veA8BkP7zbQbJXO
	H+ezlMyGKBrH0Gqi7LjNW45ZxQ==
X-Google-Smtp-Source: ABdhPJytsn78H77dX2rP3b/L21QrfpdragJRy3W8DFsJ63aYXK4fLRkRLhVd063NJTLQ1Lsw42NMfg==
X-Received: by 2002:a05:6512:260a:b0:43d:909a:50cf with SMTP id bt10-20020a056512260a00b0043d909a50cfmr12259911lfb.195.1653206240048;
        Sun, 22 May 2022 00:57:20 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id y16-20020a056512045000b004786e029146sm43406lfk.14.2022.05.22.00.57.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 May 2022 00:57:19 -0700 (PDT)
Message-ID: <7c1598a9-476d-0115-ab13-11dfa0d89436@linaro.org>
Date: Sun, 22 May 2022 09:57:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 3/5] dt-bindings: arm: qcom: Add sc7180 Chromebook
 board bindings
Content-Language: en-US
To: Douglas Anderson <dianders@chromium.org>, Rob Herring
 <robh+dt@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Matthias Kaehlcke <mka@chromium.org>,
 Alexandru M Stan <amstan@chromium.org>, patches@lists.linux.dev,
 linux-arm-msm@vger.kernel.org, Julius Werner <jwerner@chromium.org>,
 Andy Gross <agross@kernel.org>, Stephen Boyd <swboyd@chromium.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Rajendra Nayak <quic_rjendra@quicinc.com>,
 "Joseph S . Barrera III" <joebar@chromium.org>, devicetree@vger.kernel.org,
 Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
References: <20220520143502.v4.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
 <20220520143502.v4.3.I9804fcd5d6c8552ab25f598dd7a3ea71b15b55f0@changeid>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220520143502.v4.3.I9804fcd5d6c8552ab25f598dd7a3ea71b15b55f0@changeid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/05/2022 23:38, Douglas Anderson wrote:
> This copy-pastes compatibles from sc7180-based boards from the device
> trees to the yaml file so that `make dtbs_check` will be happy.
> 
> NOTES:
> - I make no attempt to try to share an "item" for all sc7180 based
>   Chromebooks. Because of the revision matching scheme used by the
>   Chromebook bootloader, at times we need a different number of
>   revisions listed.
> - Some of the odd entries in here (like google,homestar-rev23 or the
>   fact that "Google Lazor Limozeen without Touchscreen" changed from
>   sku5 to sku6) are not typos but simply reflect reality.
> - Many revisions of boards here never actually went to consumers, but
>   they are still in use within various companies that were involved in
>   Chromebook development. Since Chromebooks are developed with an
>   "upstream first" methodology, having these revisions supported with
>   upstream Linux is important. Making it easy for Chromebooks to be
>   developed with an "upstream first" methodology is valuable to the
>   upstream community because it improves the quality of upstream and
>   gets Chromebooks supported with vanilla upstream faster.
> 
> One other note here is that, though the bootloader effectively treats
> the list of compatibles in a given device tree as unordered, some
> people would prefer future boards to list higher-numbered revisions
> first in the list. Chromebooks here are not changing and typically
> list lower revisions first just to avoid churn.
> 
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> 
> (no changes since v3)
> 
> Changes in v3:
> - Split link to Chromebook boot doc into a separate patch.
> - Added a note to desc about revision ordering within a device tree.
> 
> Changes in v2:
> - Add link to doc about how Chromebook devicetrees work.
> - Use a "description" instead of a comment for each item.
> - Use the marketing name instead of the code name where possible.
> 
>  .../devicetree/bindings/arm/qcom.yaml         | 182 +++++++++++++++++-
>  1 file changed, 181 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
> index 5ac28e11ea7b..01e40ea40724 100644
> --- a/Documentation/devicetree/bindings/arm/qcom.yaml
> +++ b/Documentation/devicetree/bindings/arm/qcom.yaml
> @@ -219,11 +219,191 @@ properties:
>                - qcom,ipq8074-hk10-c2
>            - const: qcom,ipq8074
>  
> -      - items:
> +      - description: Qualcomm Technologies, Inc. SC7180 IDP
> +        items:
>            - enum:
>                - qcom,sc7180-idp
>            - const: qcom,sc7180
>  
> +      - description: HP Chromebook x2 11c (rev1 - 2)
> +        items:
> +          - const: google,coachz-rev1
> +          - const: google,coachz-rev2
> +          - const: qcom,sc7180
> +
> +      - description: HP Chromebook x2 11c (newest rev)
> +        items:
> +          - const: google,coachz
> +          - const: qcom,sc7180
> +
> +      - description: HP Chromebook x2 11c with LTE (rev1 - 2)
> +        items:
> +          - const: google,coachz-rev1-sku0
> +          - const: google,coachz-rev2-sku0
> +          - const: qcom,sc7180
> +
> +      - description: HP Chromebook x2 11c with LTE (newest rev)
> +        items:
> +          - const: google,coachz-sku0
> +          - const: qcom,sc7180
> +
> +      - description: Lenovo Chromebook Duet 5 13 (rev2)
> +        items:
> +          - const: google,homestar-rev2
> +          - const: google,homestar-rev23
> +          - const: qcom,sc7180
> +
> +      - description: Lenovo Chromebook Duet 5 13 (rev3)
> +        items:
> +          - const: google,homestar-rev3
> +          - const: qcom,sc7180
> +
> +      - description: Lenovo Chromebook Duet 5 13 (newest rev)
> +        items:
> +          - const: google,homestar
> +          - const: qcom,sc7180
> +
> +      - description: Acer Chromebook Spin 513 (rev0)
> +        items:
> +          - const: google,lazor-rev0
> +          - const: qcom,sc7180
> +
> +      - description: Acer Chromebook Spin 513 (rev1 - 2)
> +        items:
> +          - const: google,lazor-rev1
> +          - const: google,lazor-rev2
> +          - const: qcom,sc7180
> +
> +      - description: Acer Chromebook Spin 513 (rev3 - 8)
> +        items:
> +          - const: google,lazor-rev3
> +          - const: google,lazor-rev4
> +          - const: google,lazor-rev5
> +          - const: google,lazor-rev6
> +          - const: google,lazor-rev7
> +          - const: google,lazor-rev8
> +          - const: qcom,sc7180
> +
> +      - description: Acer Chromebook Spin 513 (newest rev)
> +        items:
> +          - const: google,lazor
> +          - const: qcom,sc7180
> +
> +      - description: Acer Chromebook Spin 513 with KB Backlight (rev1 - 2)
> +        items:
> +          - const: google,lazor-rev1-sku2
> +          - const: google,lazor-rev2-sku2
> +          - const: qcom,sc7180
> +
> +      - description: Acer Chromebook Spin 513 with KB Backlight (rev3 - 8)
> +        items:
> +          - const: google,lazor-rev3-sku2
> +          - const: google,lazor-rev4-sku2
> +          - const: google,lazor-rev5-sku2
> +          - const: google,lazor-rev6-sku2
> +          - const: google,lazor-rev7-sku2
> +          - const: google,lazor-rev8-sku2
> +          - const: qcom,sc7180
> +
> +      - description: Acer Chromebook Spin 513 with KB Backlight (newest rev)
> +        items:
> +          - const: google,lazor-sku2
> +          - const: qcom,sc7180
> +
> +      - description: Acer Chromebook Spin 513 with LTE (rev1 - 2)
> +        items:
> +          - const: google,lazor-rev1-sku0
> +          - const: google,lazor-rev2-sku0
> +          - const: qcom,sc7180
> +
> +      - description: Acer Chromebook Spin 513 with LTE (rev3 - 8)
> +        items:
> +          - const: google,lazor-rev3-sku0
> +          - const: google,lazor-rev4-sku0
> +          - const: google,lazor-rev5-sku0
> +          - const: google,lazor-rev6-sku0
> +          - const: google,lazor-rev7-sku0
> +          - const: google,lazor-rev8-sku0
> +          - const: qcom,sc7180
> +
> +      - description: Acer Chromebook Spin 513 with LTE (newest rev)
> +        items:
> +          - const: google,lazor-sku0
> +          - const: qcom,sc7180
> +
> +      - description: Acer Chromebook 511 (rev4 - rev8)
> +        items:
> +          - const: google,lazor-rev4-sku4
> +          - const: google,lazor-rev5-sku4
> +          - const: google,lazor-rev6-sku4
> +          - const: google,lazor-rev7-sku4
> +          - const: google,lazor-rev8-sku4
> +          - const: qcom,sc7180
> +
> +      - description: Acer Chromebook 511 (newest rev)
> +        items:
> +          - const: google,lazor-sku4
> +          - const: qcom,sc7180
> +
> +      - description: Acer Chromebook 511 without Touchscreen (rev4)
> +        items:
> +          - const: google,lazor-rev4-sku5
> +          - const: qcom,sc7180
> +
> +      - description: Acer Chromebook 511 without Touchscreen (rev5 - rev8)
> +        items:
> +          - const: google,lazor-rev5-sku5
> +          - const: google,lazor-rev5-sku6
> +          - const: google,lazor-rev6-sku6
> +          - const: google,lazor-rev7-sku6
> +          - const: google,lazor-rev8-sku6
> +          - const: qcom,sc7180
> +
> +      - description: Acer Chromebook 511 without Touchscreen (newest rev)
> +        items:
> +          - const: google,lazor-sku6
> +          - const: qcom,sc7180
> +
> +      - description: Sharp Dynabook Chromebook C1 (rev1)
> +        items:
> +          - const: google,pompom-rev1
> +          - const: qcom,sc7180
> +
> +      - description: Sharp Dynabook Chromebook C1 (rev2)
> +        items:
> +          - const: google,pompom-rev2

I understand why you do not share "item" (your first notes) for some of
boards, but I don't get why "google,pompom-rev1" cannot be combined with
"google,pompom-rev2". Do you see any chances to alter the bindings for
these two boards?

The same for other such cases (not newest revision).

> +          - const: qcom,sc7180
> +
> +      - description: Sharp Dynabook Chromebook C1 (newest rev)
> +        items:
> +          - const: google,pompom
> +          - const: qcom,sc7180
> +
> +      - description: Sharp Dynabook Chromebook C1 with LTE (rev1)
> +        items:
> +          - const: google,pompom-rev1-sku0
> +          - const: qcom,sc7180
> +
> +      - description: Sharp Dynabook Chromebook C1 with LTE (rev2)
> +        items:
> +          - const: google,pompom-rev2-sku0
> +          - const: qcom,sc7180
> +
> +      - description: Sharp Dynabook Chromebook C1 with LTE (newest rev)
> +        items:
> +          - const: google,pompom-sku0
> +          - const: qcom,sc7180
> +
> +      - description: Google Trogdor (newest rev)
> +        items:
> +          - const: google,trogdor
> +          - const: qcom,sc7180
> +
> +      - description: Google Trogdor with LTE (newest rev)
> +        items:
> +          - const: google,trogdor-sku0
> +          - const: qcom,sc7180
> +
>        - items:
>            - enum:
>                - qcom,sc7280-crd


Best regards,
Krzysztof
