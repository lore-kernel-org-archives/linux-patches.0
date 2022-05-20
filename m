Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850607A
	for <patches@lists.linux.dev>; Fri, 20 May 2022 13:39:34 +0000 (UTC)
Received: by mail-lf1-f47.google.com with SMTP id p4so12985632lfg.4
        for <patches@lists.linux.dev>; Fri, 20 May 2022 06:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3BeEGshpUebf40S3dI2nHaMHUGbrc9YgGRUe6v3NrQI=;
        b=6qt22nK9IyDROp+1mPdWrxlvzi6NjO9eSG5Nen/b2A4439rifjlgxwQdu1H0oZvaEI
         zsREZJlUH9Q59JA4/xx902iUi8jdSn8cRb9yxLBKOpTVgUEBc8mktfK/Gl0D93Izd/ul
         Onz+P2Nvnbw9a32QqyeG9cgY4Z4J9mdF8qFpYKjfy+87PufYse2QuuIZCUVPPDlNvAKE
         ik5nL2LZ9Bk16e0vHts9nXx0icITt1ybjlmSAmRoFKOj9CpUtY5Q+f5Jk/vtT2A2l3gX
         tjGCSyXpFudAPCrNP09RJNhINqh3uz45V4pH4Lmn9DWgW4Uk7j2mupibV5+qfh9CEpti
         MVrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3BeEGshpUebf40S3dI2nHaMHUGbrc9YgGRUe6v3NrQI=;
        b=TdGv5T9Fv3Ij0LeJe4f3CY8ku+S2Uvyu5rRKR6SW/Ps5pEBJzMRRovD9uBS/TxbtAN
         pBkJcMatoEwprLFxzW8De9lpQFsThBYmS64PmhlfT5rRBYbDzWnc7CxSIMFvFj/ge/+Z
         6Y389eaqLj6VMGW6PQeg0SeT081tOjyjUPXczug2trJdpi6DH3imOld4qn/XXiIbXv+f
         0EhdNX/B1M/fMsI+FMUd7TVFiDvG+fmjsQUMMqTd45Wf2GNCH+jPp2SnD2WHeT60aQyd
         c01Epdkv7xtxfpCcgTQyLoOTYtt/YpRITCJQnd6sV6sUROHXOdBMrM8lO0GAaG35awc0
         5b2A==
X-Gm-Message-State: AOAM531A/n+uZAu2EFv/Ui8IUbeZOSFvJTlSKVaZNWixclVF2TWje/FV
	rCID+9rjaxeNn4IGCyqPwedNFw==
X-Google-Smtp-Source: ABdhPJyT1m9j6Hn8ES8585uw0TDj+nJSjxY8pFZYdW/m0XbSSumm094xJFwQQSPevh3hEaAT3pcheQ==
X-Received: by 2002:a19:4f04:0:b0:477:b6c7:9771 with SMTP id d4-20020a194f04000000b00477b6c79771mr6778897lfb.182.1653053972054;
        Fri, 20 May 2022 06:39:32 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id e7-20020a2e9847000000b0024f3d1daeacsm323659ljj.52.2022.05.20.06.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 06:39:31 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
	id C70E6104AAB; Fri, 20 May 2022 16:41:24 +0300 (+03)
Date: Fri, 20 May 2022 16:41:24 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Jakub =?utf-8?Q?Mat=C4=9Bna?= <matenajakub@gmail.com>
Cc: linux-mm@kvack.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
	mgorman@techsingularity.net, willy@infradead.org,
	liam.howlett@oracle.com, hughd@google.com, riel@surriel.com,
	rostedt@goodmis.org, peterz@infradead.org, david@redhat.com
Subject: Re: [RFC PATCH v3 2/6] [PATCH 2/6] mm: add merging after mremap
 resize
Message-ID: <20220520134124.6glbfzhrgzutfor6@box.shutemov.name>
References: <20220516125405.1675-1-matenajakub@gmail.com>
 <20220516125405.1675-3-matenajakub@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220516125405.1675-3-matenajakub@gmail.com>

On Mon, May 16, 2022 at 02:54:01PM +0200, Jakub Matěna wrote:
> When mremap call results in expansion, it might be possible to merge the
> VMA with the next VMA which might become adjacent. This patch adds
> vma_merge call after the expansion is done to try and merge.
> 
> Signed-off-by: Jakub Matěna <matenajakub@gmail.com>
> ---
>  mm/mremap.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 303d3290b938..75cda854ec58 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <linux/mm.h>
> +#include <linux/mm_inline.h>
>  #include <linux/hugetlb.h>
>  #include <linux/shm.h>
>  #include <linux/ksm.h>
> @@ -1022,8 +1023,10 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
>  				}
>  			}
>  
> -			if (vma_adjust(vma, vma->vm_start, addr + new_len,
> -				       vma->vm_pgoff, NULL)) {
> +			if (!vma_merge(mm, vma, addr + old_len, addr + new_len,
> +					vma->vm_flags, vma->anon_vma, vma->vm_file,
> +					vma->vm_pgoff + (old_len >> PAGE_SHIFT), vma_policy(vma),
> +					vma->vm_userfaultfd_ctx, anon_vma_name(vma))) {

Hm. Don't you need to update 'vma' with result of vma_merge()?

'vma' is used below the point and IIUC it can be use-after-free.

-- 
 Kirill A. Shutemov
