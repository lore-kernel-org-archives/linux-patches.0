Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9AA36D;
	Wed,  8 Mar 2023 22:36:05 +0000 (UTC)
Received: by mail-ed1-f50.google.com with SMTP id i34so71833472eda.7;
        Wed, 08 Mar 2023 14:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678314964;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jzDf4+4sG/Th13nL0Nk+rTjw3K6s3TCf1TZrS78TwVk=;
        b=TKYPU3ZRnNzZcIrmpbFdrOELb3qHa4Mmd5uxjy5Awp0yXXXvcwOqQf7P4LJRy6hkvm
         356DfYqVabeiY6tfx37KrcRPlwazFBeFFB9Tfnx+EGs0XQr2QklDBe15O3uLbQEeDkAH
         JmAbzE6hh+DjMf80YADuMmOQEB+qci9YSSMdgo0AIOXb5GeAeoAx5z2V/5hfke90LAtN
         4HhBVyxVkWoEeVADYD4Ktn11RWIcpUdql83m+s3RlPW/v5kQ1tvko9IhKGHHdQcs5GRS
         tH19/5tiBmopZIsq2eiEuXXp73MF6ezkSL6HYF1SHmoSgQJ7NYIHmtkVH/LK0IG3dBK1
         7Lsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678314964;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jzDf4+4sG/Th13nL0Nk+rTjw3K6s3TCf1TZrS78TwVk=;
        b=v449lZ5i+rxjYap1bKcrZtO1TPq37dZe0LMBhom125r98H5Zeaq4TEgAstuX/Qp+7O
         tVtU8braG0Gbyo/qt3VCuFqCgaa05EyNlvbtXR7KMvSRO8AeyQRTz7HFtW1ft0fba1zb
         1shlAIect1BrQtgghCq0Bjh8I9GfRkDibJC9GCJG8OB9aesv1pRHNo604diiGcPh6f1K
         0dZU2AoGOe2GIwr6QHRW9BkwskltJ+HW9kFJ8+6FuuO342ppCuZwHPxgZY0TTiv4ujZ3
         AKL0Wt9F2qq8bssUjRCSoUWa3eUOAS/MJzmpfXpucKzqy5hWjum6ZhwEXvTgH22J7Dsl
         2a4A==
X-Gm-Message-State: AO0yUKWJ+XoBO0rbj8dgmUETKXdNccOWV8IoN4erAYDCh8M3bMuDbmrK
	eaqXFCG+yRmsPU0sbR0FV1Q=
X-Google-Smtp-Source: AK7set/8kMxm9e7Ww76G9dAgDiHgWhS+pXwdbv/atF+1sdRH7bnZyj6ZiiACFFD6T7xTA7L5lspPLA==
X-Received: by 2002:a17:907:7748:b0:8e8:6b69:2093 with SMTP id kx8-20020a170907774800b008e86b692093mr22362157ejc.25.1678314963862;
        Wed, 08 Mar 2023 14:36:03 -0800 (PST)
Received: from [192.168.0.151] (ip5f5abbd3.dynamic.kabel-deutschland.de. [95.90.187.211])
        by smtp.gmail.com with ESMTPSA id q1-20020a50c341000000b004bbb691a334sm8862127edb.2.2023.03.08.14.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 14:36:03 -0800 (PST)
Message-ID: <9e4d7f04-3114-8240-341b-1fff5ae69b0b@gmail.com>
Date: Wed, 8 Mar 2023 23:36:02 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] staging: r8188eu: delete driver
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-staging@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Hans de Goede <hdegoede@redhat.com>, Martin Kaiser <martin@kaiser.cx>,
 Larry Finger <Larry.Finger@lwfinger.net>,
 Phillip Potter <phil@philpotter.co.uk>, Pavel Skripkin <paskripkin@gmail.com>
References: <20230308131934.380395-1-gregkh@linuxfoundation.org>
Content-Language: en-US
From: Michael Straube <straube.linux@gmail.com>
In-Reply-To: <20230308131934.380395-1-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/23 14:19, Greg Kroah-Hartman wrote:
> Now that the same hardware that the r8188eu driver supported is
> supported by the real wireless driver rtl8xxxu, the r8188eu driver can
> be deleted.
> 
> Also the rtl8xxxu driver supports way more devices, and is a fraction of
> the overall size, making this a much better overall solution.
> 
> Thanks to the r8188eu developers and maintainers and reviewers over the
> years, your work allowed Linux users to use their hardware before the
> real driver was implemented properly.
> 
> Reported-by: Hans de Goede <hdegoede@redhat.com>
> Cc: Martin Kaiser <martin@kaiser.cx>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Phillip Potter <phil@philpotter.co.uk>
> Cc: Pavel Skripkin <paskripkin@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

The rtl8xxxu driver works well for me.

Acked-by: Michael Straube <straube.linux@gmail.com>

