Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009AC2C9E
	for <patches@lists.linux.dev>; Thu, 27 Jan 2022 22:46:04 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id e6so4311540pfc.7
        for <patches@lists.linux.dev>; Thu, 27 Jan 2022 14:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5baFyXldvQMErFU+/ifbyciqTBCmZNJDFU4jFRID7Sc=;
        b=jc5NcQe5YZDoJ8NVYCY0XyYexoxkcBDTwpQPjuG/lEMLr+zJUaq5FPhRACD01OV9Wv
         XR2Xp6NMg3zfcFPeg8cMdfUuiSigVhuUYet7Ll4ht3A5gt1I35lrOqr/ye/dkOWugt+G
         GeymfKAWdOf8t1KPcYXfR3t5se1bo8I//nmwZACwmcE8RMSdWoK7HXphWji4JR2pigtE
         Rau+TBN4vRoRG2HFz6EmhS2gZJLyoV05tVA5Rl2P4rTCPW0VqZdeX5hyOO0Ma5FX9/sD
         PsuqJD3j+xCvzM8F+ikQ8eN4Bm/SX6A0a0PXgLB+aDFLV1nBmzLr++HnOevLY/NLNQME
         UNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5baFyXldvQMErFU+/ifbyciqTBCmZNJDFU4jFRID7Sc=;
        b=cQ5qp+XoFE+C6jzhmUYWhk9qw+NFBmwmTLjegGZuy4ghP0ry+vG9s53JhokCY36+Sm
         pxZyzNyNBsu5CGaau7iehjcPEs6hPKRVt7TKEDEP5BNGo1b8WFDuf1EZk+1kzbDxMS3d
         edJO1yyAvArAlVt7wWC39KuQNLEqlcRERg45c1KPc13hp2+u/GVnIghL4Hrx9rBAvsKA
         RUJlobek6gEfzCARG+kMcj9RRu7lXH4R7bbR8yoRxE4IxT8cVBIwykgVTxx0/7PyPdu6
         GiwCGQakItu5LNJf1Z30y6e2tsODTGwdIo2H9xeipY1IX44VCVVAaFgtZfqQ6ta6Z1Si
         ScmQ==
X-Gm-Message-State: AOAM530SdC/U7AwxsLis31idRbcCcikjDGWWT+m1zdMOCRkFUYkyjKEG
	bdBuU+i45OqLz3MNnEQdVyU0ULfJ40wiWjHG9e5gdw==
X-Google-Smtp-Source: ABdhPJzEmxxk1ppI610r8vxQ20er+wXH07RAWUU25vYVKbXyfrMjJazNJ+F9r1YtkkAP1AtheniX47agrsCbnenki90=
X-Received: by 2002:a63:550f:: with SMTP id j15mr4335426pgb.40.1643323564338;
 Thu, 27 Jan 2022 14:46:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220127212911.127741-1-ben.widawsky@intel.com> <20220127212911.127741-3-ben.widawsky@intel.com>
In-Reply-To: <20220127212911.127741-3-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Jan 2022 14:45:53 -0800
Message-ID: <CAPcyv4irOFTkrtAai7SLK1pdKNceQv83JrVoh5P5Px5xC5t3WQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] cxl/core: Add more decoder attributes to sysfs
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 27, 2022 at 1:29 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> The decoder attributes are consumed by userspace in order to program and
> verify the CXL topology.
>
> An example of the new attributes is with x1 and 8192 granularity:
> archlinux ~ # cat /sys/bus/cxl/devices/decoder0.0/interleave_{ways,granularity}
> 1
> 8192
>
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> ---
>  drivers/cxl/core/port.c | 21 +++++++++++++++++++++

Looks good, just missing the update to Documentation/ABI/testing/sysfs-bus-cxl
