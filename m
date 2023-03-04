Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189CC7E
	for <patches@lists.linux.dev>; Sat,  4 Mar 2023 14:48:56 +0000 (UTC)
Received: by mail-qv1-f43.google.com with SMTP id ks17so3707225qvb.6
        for <patches@lists.linux.dev>; Sat, 04 Mar 2023 06:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677941336;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TsKKHJ0/GD+1zuzNsuCdWtAJjvxya3Twz8P8LNYqCwY=;
        b=o0XqqF9KH2cTPnL75tHljXD8nVLW6wpV2NwV7X4XXX+8CRd/3AiCnKdEDZYSwR76vS
         z8DZ8fDxhR9+Ldwet6gfGkh2EsHwkG4Dy7dIJF9dPCMa6YH7fOTsxGPuSPTCkAS8XnXz
         OfwYYEu30tPOkw33e6UktE/vuadPB2J8SBzRq91ZzIsoBzpFT+a/OEoRYN3MxofBSzE3
         n2D3eHQaHuIWSse1usU0WLHDT0VedC2vd3YjKYqeoWc8J/YzpCrNaTcZorTn2ZaYobKj
         vcDaPFP2HtRgLwcyZQk40ii3Uxz5WJNVJ4F+7fU5RfFO0z0TzUrHE3mMAIJLs5FvwND4
         pCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677941336;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TsKKHJ0/GD+1zuzNsuCdWtAJjvxya3Twz8P8LNYqCwY=;
        b=c0F2nOrZkannOnWWpqjN3tJRGcF19utoaB1+UodpfhsHK0qkYDMKlevmbq7x4G35CC
         uopDiuEhI0RFgLgOyi9Iok0ZNZVn/aeL7y84WcFVUyOTH2M/6ejRArQ5t29PZMsNa7WY
         wO7Rab8hCR/Tw16GoTy5GbOnQ9GiaNoyG9Y99o6m2MLqLiILemAtYXsg1alVDHa9Ca1m
         rILiPr6bUlF13Ura6eD0Cj4QdkkUhcwD2sC8zQvH+hcOt6I+F6TCZk99qX9neyVe+Wt5
         BFxxSrAmQ8sXTFcaGD+347lDgl6AUhWX7VwtTpiSSwLJg+yQ8Lqk5JQJHZe2xIzTTqx5
         i9XA==
X-Gm-Message-State: AO0yUKVlIgBRzVjvLt86F9W68iMjxWIojHReXfHoWRmjTXsh1ATKjm/x
	xytLgueC8tzPzOPLOLOEYjg=
X-Google-Smtp-Source: AK7set/lpTeE6jSzoh7eLRmNQ2aPTpe64xLeLcMiiEyIor3lA8OcSo+NeLshc41rysf1tZHsq/I8fQ==
X-Received: by 2002:a05:6214:23c8:b0:583:a07b:554c with SMTP id hr8-20020a05621423c800b00583a07b554cmr2306311qvb.40.1677941335935;
        Sat, 04 Mar 2023 06:48:55 -0800 (PST)
Received: from ?IPV6:2600:1700:2442:6db0:99e6:eec3:1daa:f163? ([2600:1700:2442:6db0:99e6:eec3:1daa:f163])
        by smtp.gmail.com with ESMTPSA id d82-20020a376855000000b007419eb86df0sm3835899qkc.127.2023.03.04.06.48.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Mar 2023 06:48:55 -0800 (PST)
Message-ID: <6668e83c-eb2c-7ac9-7b6f-2c8146c2175d@gmail.com>
Date: Sat, 4 Mar 2023 08:48:54 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 0/8] clk: Add kunit tests for fixed rate and parent data
Content-Language: en-US
To: Rob Herring <robh+dt@kernel.org>, David Gow <davidgow@google.com>,
 Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
 linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
 patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Richard Weinberger
 <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Vincent Whitchurch <vincent.whitchurch@axis.com>,
 Christian Marangi <ansuelsmth@gmail.com>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 devicetree@vger.kernel.org, linux-um@lists.infradead.org,
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
References: <20230302013822.1808711-1-sboyd@kernel.org>
 <CABVgOSnpMNCtEEsJV28OzUoxdDuiT4a2T0avP0AYf9xFW1jxrw@mail.gmail.com>
 <CAL_JsqJMd3Fi0ZBObdyE1VDKTH1_+smuGDymHnKOkVH2HB3jJQ@mail.gmail.com>
From: Frank Rowand <frowand.list@gmail.com>
In-Reply-To: <CAL_JsqJMd3Fi0ZBObdyE1VDKTH1_+smuGDymHnKOkVH2HB3jJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/2/23 11:32, Rob Herring wrote:
> On Thu, Mar 2, 2023 at 2:14 AM David Gow <davidgow@google.com> wrote:
>>
>> On Thu, 2 Mar 2023 at 09:38, Stephen Boyd <sboyd@kernel.org> wrote:
>>>
>>> This patch series adds unit tests for the clk fixed rate basic type and
>>> the clk registration functions that use struct clk_parent_data. To get
>>> there, we add support for loading a DTB into the UML kernel that's
>>> running the unit tests along with probing platform drivers to bind to
>>> device nodes specified in DT.
>>>
>>> With this series, we're able to exercise some of the code in the common
>>> clk framework that uses devicetree lookups to find parents and the fixed
>>> rate clk code that scans devicetree directly and creates clks. Please
>>> review.
>>>
>>
>> Thanks Stephen -- this is really neat!
>>
>> This works well here, and I love all of the tests for the
>> KUnit/device-tree integration as well.
>>
>> I'm still looking through the details of it (alas, I've mostly lived
>> in x86-land, so my device-tree knowledge is, uh, spotty to say the
>> least), but apart from possibly renaming some things or similarly
>> minor tweaks, I've not got any real suggestions thus far.
>>
>> I do wonder whether we'll want, on the KUnit side, to have some way of
>> supporting KUnit device trees on non-UML architecctures (e.g., if we
>> need to test something architecture-specific, or on a big-endian
>> platform, etc), but I think that's a question for the future, rather
>> than something that affects this series.
> 
> I'll say that's a requirement. We should be able to structure the
> tests to not interfere with the running system's DT. The DT unittest
> does that.
> 
> As a side topic, Is anyone looking at getting UML to work on arm64?
> It's surprising how much x86 stuff there is which is I guess one
> reason it hasn't happened.
> 
>> Similarly, I wonder if there's something we could do with device tree
>> overlays, in order to make it possible for tests to swap nodes in and
>> out for testing.
> 
> Yes, that's how the DT unittest works. But it is pretty much one big
> overlay (ignoring the overlay tests). It could probably be more
> modular where it is apply overlay, test, remove overlay, repeat.

Actually, no, the bulk of the DT unittest devicetree data is _not_ an
overlay.  It is an FDT that is loaded via of_fdt_unflatten_tree() instead
of the overlay load API.  Note that the base DT unittest runs with
  CONFIG_OF_DYNAMIC=n
  CONFIG_OF_OVERLAY=n
so the overlay support code is not even present in the built kernel.

One can then enable CONFIG_OF_DYNAMIC to test the dynamic code.

One can further enable CONFIG_OF_OVERLAY to test the overlay code
(this will in turn select CONFIG_OF_DYNAMIC if not already enabled).

I would strongly discourage use of the overlay APIs for kunit tests,
unless the point of the kunit test is to test the overlay API.  Basic
tests should always be performed with devicetree data that has been
populated by the normal processing of an FDT during early boot.  If
one want to test proper overlay infrastructure functionality, then
those (essentially) same basic tests could/should be repeated with
devicetree data that has been populated by loading an overlay.

> 
> Rob

