Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18EE1C3F
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 02:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nrL/fXCD"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-1fa235f8026so1736976fac.3
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 18:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701140033; x=1701744833; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yLLWv5heZEhgKjwCSN7z2+gMmcOBqEVERQWxP5YYCuA=;
        b=nrL/fXCD5/0ILez2ZvyyAlO+tWV8ZubtwyNJxE3pGLS+V6rOeQLdH7sQW2t3yrhmWJ
         hzenpgqHjt+s4k/qF+4oXZ5Xs15d5ct9rMLzPRE0441LdAtCbwU+45SKXImJ42peko8l
         ckYIRd3HqhF45syoSEPJC5eVNUPYEZ8gObhLUzFiaKws0Ed73qYl+Oj+xtAzb2lVxz+R
         fn9PobKgXG/gTU9HAWI4ts+vNixYBp8j7h1c3vUWR073tDngR7Xyh5PvtqDMHh7X7d6x
         YaEXwNsWOvLQGVQH8UtRtcc2MDQdMfRpPuF29WBsLNGNW+qhLWQYaz4sbBDs2mPK5nkP
         T9Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701140033; x=1701744833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yLLWv5heZEhgKjwCSN7z2+gMmcOBqEVERQWxP5YYCuA=;
        b=cGkF5J3yBsC5/Yf36zBM3CaKe/B4dv3nVZ91OvYqAK0rZOPY2utjBikd3lvYvAs2bm
         PIyClv4z6fFirC4iHbfODgDETUUfwBiVkjOyyjqDIQOtsaFUjxCcJ4x7zOkWq4Oxuj4n
         rtToILPXgVf1cS9T4J7POOZpki822sC483BT8DOpO2dUePaPzUzD9xslpKnsuV9+cnRB
         iPpGqRJkKbituT6XKdRhC77qPYgAlq8lgwuRZXMC5bzKk061IxfVZ0ptWfU4lchZjdza
         JnYtoBAPTLWz5Wq0CYKLz87AXdo2x+v+ycE0j4qQIbh4oMqZ1q0nGU+msDHmsNjeuV9E
         oTxw==
X-Gm-Message-State: AOJu0Yx8N0EDmy3tppVq+ge7T7tvtOnnhaMCxTDX4L9epD0doTtnBHpQ
	rlI29RIEReKM7xAXBshLbYc=
X-Google-Smtp-Source: AGHT+IF6jVKPFA8DG3pvBSHDGK4YiOzVX/zHwlGp7anDdmqYkUM8Gk1njhG5sEjns0CVgOWHm5cb7A==
X-Received: by 2002:a05:6871:438b:b0:1f9:8f72:4302 with SMTP id lv11-20020a056871438b00b001f98f724302mr18234988oab.59.1701140033150;
        Mon, 27 Nov 2023 18:53:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s12-20020a056830438c00b006ce2f0818d3sm1559110otv.22.2023.11.27.18.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 18:53:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 27 Nov 2023 18:53:51 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/366] 6.1.64-rc4 review
Message-ID: <2956fbdf-8e58-44f0-893c-4c32b34b95ee@roeck-us.net>
References: <20231126154359.953633996@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231126154359.953633996@linuxfoundation.org>

On Sun, Nov 26, 2023 at 03:46:28PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.64 release.  There
> are 366 patches in this series, all will be posted as a response to this one.
> If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.  Anything
> received after that time might be too late.
> 

For v6.1.63-367-g40fd07331b87:

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 529 pass: 529 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
