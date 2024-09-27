Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9539171092
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 04:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727410453; cv=none; b=FoL+iJQvC70YcxM0paeAJ9NCGgddw8eADsqJuNORePxwCe42iyKeIDUEnU2kS/OHMiiQ9uadJthCHJs8JNgTPOov5BhcQXp/pd73B2tHDxpPlJQMFIxQBMPXCyAbVVsbRcxsMqhsd56vMpWExSMF+yd1PzA5nK0N6q8mfCaSUQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727410453; c=relaxed/simple;
	bh=JVL2fUPhe7PhfPh2yglWF3nfspxFiAyHvNIEuOzsF4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VE04jW3FGvpLXcO40vPcc42nMqSstjl9XUQbC1/MNBjRf6JnElYIpMiqMhzPE/KPF5lWamkcMPRF3++m76t59WiTyWE0zE8iM64KFrBE9lQLglsA2o/1fSx4D0cgqdEHO1+wCfpckE/Vp7alMvaM3TJRDX9hgB4m6yul/BJenMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yryo6oG/; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yryo6oG/"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2055136b612so21467745ad.0
        for <patches@lists.linux.dev>; Thu, 26 Sep 2024 21:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727410451; x=1728015251; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zmPC7xOEq4xiQYbTsTCCja7E17GlGBjk59a6Y6qmbow=;
        b=Yryo6oG/mjfyzLseKldZNhZ5mtxv7HsUYaL5izifibAitFyxERvSZtc8ZgycU8bzSw
         J4narjnuF5y+asIN1Vha2DE4fnu8gJUhryoDmv1x/qUwjRACjZJmJ2Y053tVzIfVKyn+
         9R+vW3oKEDdT6qWvR2kQRg+bemV0B0JphD6JI+6Y6N1MEFDlMHkkw9vlwxkIRDtlb3eO
         EqCo9sXRg7EYVKUGX7SKX7YXU0SGtuauwTYSzfx24GppNmarN2fkSXtV+PaSEetdOE5n
         wEcrQfYKzOXegNbkyjEv3Y2hWIbq97IdggPduae7dNnhvi2INiZKJeGHUuM0Ir/+8cwO
         rMdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727410451; x=1728015251;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zmPC7xOEq4xiQYbTsTCCja7E17GlGBjk59a6Y6qmbow=;
        b=VC8NzJPFnwaOnqz9cwTFnHnfDPPgGO/O3LEQTmegtX6TG8vr6lTsvZ32eF93zzz+wn
         TBhv25aLFFyoeDSNwHu4jXCgTmqzZIeueU+NvsiyyptTFYKMqePmV4brjvBcV7HrujPU
         0Dk2n3Hnqh2r7hZ5gVXZXJ9pKLVcJZ3m1ekm9Lpu2mRmhGKtaqizOscyH8sIcktDXx6t
         mnulGSfzc/brCda6AliO03aAg0kVgbESc99ARCiT7n5tBVkwdiT2N6u4sL86C0GfETIi
         vXOVX6q+GCdOQRD27dBu6jAJjMU9SBX8VO4OF00/2is+GXfT3nSYwGFdvlOqLZQCX5x5
         g8JA==
X-Forwarded-Encrypted: i=1; AJvYcCULgk9gbTSQ8tn+2we1HPeAJff3HlAoNi4TuWHoEFZDkAF5NA5LpbLq5vEZ4KsopyghzTsyxXkq@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1xBs8cTYxapmZfX3hO8K6VNmUnXkB7rutrTYcrTdsw1p54vAV
	B1FaUemrpwtPHU+TKmYj8URvaQext0k9N1coiI9VuwvG6QltKlHO
X-Google-Smtp-Source: AGHT+IHDmvSZ+vvEz962F4lkQhrBabPVtLhowwYwbXZHolk9sYGt9iof/C7/GGTTa5vwr7vZ0BjGBw==
X-Received: by 2002:a17:902:da81:b0:206:adf0:4f15 with SMTP id d9443c01a7336-20b367d035emr34323555ad.8.1727410450894;
        Thu, 26 Sep 2024 21:14:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e6db2bc531sm689914a12.32.2024.09.26.21.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 21:14:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 26 Sep 2024 21:14:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
	patches@lists.linux.dev, kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org, devicetree@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	Daniel Latypov <dlatypov@google.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Maxime Ripard <maxime@cerno.tech>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH v8 8/8] clk: Add KUnit tests for clks registered with
 struct clk_parent_data
Message-ID: <6cd337fb-38f0-41cb-b942-5844b84433db@roeck-us.net>
References: <20240718210513.3801024-1-sboyd@kernel.org>
 <20240718210513.3801024-9-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240718210513.3801024-9-sboyd@kernel.org>

Hi Stephen,

On Thu, Jul 18, 2024 at 02:05:07PM -0700, Stephen Boyd wrote:
> Test that clks registered with 'struct clk_parent_data' work as
> intended and can find their parents.
> 

When testing this on arm64, I see the error below. The error is only
seen if I boot through efi, i.e., with "-bios QEMU_EFI-aarch64.fd"
qemu parameter.

Any idea what might cause the problem ?

Thanks,
Guenter

---
[   20.464809]     KTAP version 1
[   20.464865]     # Subtest: clk_register_clk_parent_data_of
[   20.464936]     # module: clk_test
[   20.464979]     1..1
[   20.465098]         KTAP version 1
[   20.465208]         # Subtest: clk_register_clk_parent_data_of_test
[   20.468964] OF: overlay: find target, node: /fragment@0, path '/' not found
[   20.469558] OF: overlay: init_overlay_changeset() failed, ret = -22
[   20.470177]     # clk_register_clk_parent_data_of_test: ASSERTION FAILED at drivers/clk/clk_test.c:2760
[   20.470177]     Expected 0 == ({ extern uint8_t __dtbo_kunit_clk_parent_data_test_begin[]; extern uint8_t __dtbo_kunit_clk_parent_data_test_end[]; __of_overlay_apply_kunit((test), __dtbo_kunit_clk_parent_data_test_begin, __dtbo_kunit_clk_parent_data_test_end); }), but
[   20.470177]         ({ extern uint8_t __dtbo_kunit_clk_parent_data_test_begin[]; extern uint8_t __dtbo_kunit_clk_parent_data_test_end[]; __of_overlay_apply_kunit((test), __dtbo_kunit_clk_parent_data_test_begin, __dtbo_kunit_clk_parent_data_test_end); }) == -22 (0xffffffffffffffea)
[   20.471793]         not ok 1 clk_parent_data_of_index_test
[   20.474095] OF: overlay: find target, node: /fragment@0, path '/' not found
[   20.474373] OF: overlay: init_overlay_changeset() failed, ret = -22
[   20.474737]     # clk_register_clk_parent_data_of_test: ASSERTION FAILED at drivers/clk/clk_test.c:2760
[   20.474737]     Expected 0 == ({ extern uint8_t __dtbo_kunit_clk_parent_data_test_begin[]; extern uint8_t __dtbo_kunit_clk_parent_data_test_end[]; __of_overlay_apply_kunit((test), __dtbo_kunit_clk_parent_data_test_begin, __dtbo_kunit_clk_parent_data_test_end); }), but
[   20.474737]         ({ extern uint8_t __dtbo_kunit_clk_parent_data_test_begin[]; extern uint8_t __dtbo_kunit_clk_parent_data_test_end[]; __of_overlay_apply_kunit((test), __dtbo_kunit_clk_parent_data_test_begin, __dtbo_kunit_clk_parent_data_test_end); }) == -22 (0xffffffffffffffea)
[   20.477677]         not ok 2 clk_parent_data_of_fwname_test
[   20.479773] OF: overlay: find target, node: /fragment@0, path '/' not found
[   20.479941] OF: overlay: init_overlay_changeset() failed, ret = -22
[   20.480160]     # clk_register_clk_parent_data_of_test: ASSERTION FAILED at drivers/clk/clk_test.c:2760
[   20.480160]     Expected 0 == ({ extern uint8_t __dtbo_kunit_clk_parent_data_test_begin[]; extern uint8_t __dtbo_kunit_clk_parent_data_test_end[]; __of_overlay_apply_kunit((test), __dtbo_kunit_clk_parent_data_test_begin, __dtbo_kunit_clk_parent_data_test_end); }), but
[   20.480160]         ({ extern uint8_t __dtbo_kunit_clk_parent_data_test_begin[]; extern uint8_t __dtbo_kunit_clk_parent_data_test_end[]; __of_overlay_apply_kunit((test), __dtbo_kunit_clk_parent_data_test_begin, __dtbo_kunit_clk_parent_data_test_end); }) == -22 (0xffffffffffffffea)
[   20.481513]         not ok 3 clk_parent_data_of_name_test
[   20.483711] OF: overlay: find target, node: /fragment@0, path '/' not found
[   20.483878] OF: overlay: init_overlay_changeset() failed, ret = -22
[   20.484100]     # clk_register_clk_parent_data_of_test: ASSERTION FAILED at drivers/clk/clk_test.c:2760
[   20.484100]     Expected 0 == ({ extern uint8_t __dtbo_kunit_clk_parent_data_test_begin[]; extern uint8_t __dtbo_kunit_clk_parent_data_test_end[]; __of_overlay_apply_kunit((test), __dtbo_kunit_clk_parent_data_test_begin, __dtbo_kunit_clk_parent_data_test_end); }), but
[   20.484100]         ({ extern uint8_t __dtbo_kunit_clk_parent_data_test_begin[]; extern uint8_t __dtbo_kunit_clk_parent_data_test_end[]; __of_overlay_apply_kunit((test), __dtbo_kunit_clk_parent_data_test_begin, __dtbo_kunit_clk_parent_data_test_end); }) == -22 (0xffffffffffffffea)
[   20.485444]         not ok 4 clk_parent_data_of_fwname_name_test
[   20.487432] OF: overlay: find target, node: /fragment@0, path '/' not found
[   20.487600] OF: overlay: init_overlay_changeset() failed, ret = -22
[   20.487841]     # clk_register_clk_parent_data_of_test: ASSERTION FAILED at drivers/clk/clk_test.c:2760
[   20.487841]     Expected 0 == ({ extern uint8_t __dtbo_kunit_clk_parent_data_test_begin[]; extern uint8_t __dtbo_kunit_clk_parent_data_test_end[]; __of_overlay_apply_kunit((test), __dtbo_kunit_clk_parent_data_test_begin, __dtbo_kunit_clk_parent_data_test_end); }), but
[   20.487841]         ({ extern uint8_t __dtbo_kunit_clk_parent_data_test_begin[]; extern uint8_t __dtbo_kunit_clk_parent_data_test_end[]; __of_overlay_apply_kunit((test), __dtbo_kunit_clk_parent_data_test_begin, __dtbo_kunit_clk_parent_data_test_end); }) == -22 (0xffffffffffffffea)
[   20.489207]         not ok 5 clk_parent_data_of_index_name_priority_test
[   20.490998] OF: overlay: find target, node: /fragment@0, path '/' not found
[   20.491504] OF: overlay: init_overlay_changeset() failed, ret = -22
[   20.491725]     # clk_register_clk_parent_data_of_test: ASSERTION FAILED at drivers/clk/clk_test.c:2760
[   20.491725]     Expected 0 == ({ extern uint8_t __dtbo_kunit_clk_parent_data_test_begin[]; extern uint8_t __dtbo_kunit_clk_parent_data_test_end[]; __of_overlay_apply_kunit((test), __dtbo_kunit_clk_parent_data_test_begin, __dtbo_kunit_clk_parent_data_test_end); }), but
[   20.491725]         ({ extern uint8_t __dtbo_kunit_clk_parent_data_test_begin[]; extern uint8_t __dtbo_kunit_clk_parent_data_test_end[]; __of_overlay_apply_kunit((test), __dtbo_kunit_clk_parent_data_test_begin, __dtbo_kunit_clk_parent_data_test_end); }) == -22 (0xffffffffffffffea)
[   20.493053]         not ok 6 clk_parent_data_of_index_fwname_name_priority_test
[   20.493583]     # clk_register_clk_parent_data_of_test: pass:0 fail:6 skip:0 total:6
[   20.493701]     not ok 1 clk_register_clk_parent_data_of_test
[   20.493822] # clk_register_clk_parent_data_of: pass:0 fail:1 skip:0 total:1
[   20.493920] # Totals: pass:0 fail:6 skip:0 total:6
[   20.494032] not ok 49 clk_register_clk_parent_data_of
