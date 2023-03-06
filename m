Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B519320E
	for <patches@lists.linux.dev>; Mon,  6 Mar 2023 15:27:11 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id j2so9210390wrh.9
        for <patches@lists.linux.dev>; Mon, 06 Mar 2023 07:27:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678116429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WjzbTdN7CLD76LwUYgSQFGlrkv+uCLMJlqFIMmRORpA=;
        b=4Eu2gnMceW+M8DZYtBd2Bnpimuqdh8kzbYbeQm6hdiape3bxyVXcD3TuwQfYB1PcUq
         ej+ECPe0ilMWk/6K+VVo9V9gk91qwekzoigKredtIDPZkASnHNVDGeQTlS7yH3cZvnam
         zqPZEmtzFC76nfxH+f7vkifah/IRx6Uqgf/3VNZL+1k61GdCcFazgJLyrZmG7rsTpwYI
         6v/v+r2as6Do/INkGRUQXoL3iM5wFTbYynXyrWcZQWaUxQQUk0p9xpmWIBin7YbCFRA8
         5L1+gn8qLxfNkFg7skwbofG+tD8pp8YN0S9gRoQAV0s1NA4dhnOLGhIdH9fSSq+165k6
         oZUw==
X-Gm-Message-State: AO0yUKXLSFC2dyE5dzYGnDY0uhAkUq5ZiFlCIpmrB3RUBXWPqwD0RlCy
	IBCn0sWhH8XNa/13Yk3H27I=
X-Google-Smtp-Source: AK7set8sLVDUwT8GQGScn0gVSp+FOGcmG6WKTOjmYMNL/6orgxuEwPFL/9jsyQwuVKKF6cXajJRglg==
X-Received: by 2002:adf:eb4b:0:b0:2c6:e744:cf71 with SMTP id u11-20020adfeb4b000000b002c6e744cf71mr6185222wrn.52.1678116429360;
        Mon, 06 Mar 2023 07:27:09 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id r1-20020a056000014100b002c5534db60bsm10414947wrx.71.2023.03.06.07.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 07:27:08 -0800 (PST)
Date: Mon, 6 Mar 2023 15:27:03 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com, minyard@acm.org,
	kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, song@kernel.org, robinmholt@gmail.com,
	steve.wahl@hpe.com, mike.travis@hpe.com, arnd@arndb.de,
	gregkh@linuxfoundation.org, jirislaby@kernel.org, jgross@suse.com,
	sstabellini@kernel.org, oleksandr_tyshchenko@epam.com,
	xen-devel@lists.xenproject.org, j.granados@samsung.com,
	zhangpeng362@huawei.com, tangmeng@uniontech.com,
	willy@infradead.org, nixiaoming@huawei.com, sujiaxun@uniontech.com,
	patches@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-raid@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-hyperv@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] hv: simplify sysctl registration
Message-ID: <ZAYGR4DFQrjZVpC5@liuwe-devbox-debian-v2>
References: <20230302204612.782387-1-mcgrof@kernel.org>
 <20230302204612.782387-4-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302204612.782387-4-mcgrof@kernel.org>

On Thu, Mar 02, 2023 at 12:46:08PM -0800, Luis Chamberlain wrote:
> register_sysctl_table() is a deprecated compatibility wrapper.
> register_sysctl() can do the directory creation for you so just use
> that.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
