Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B327526ED5D;
	Mon, 24 Nov 2025 01:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763948413; cv=none; b=ZDk5hvaKpCqfWnd8+iIOTWJzOGu2qDrnF2YoMuQD/UF8FniAOqBpyJwW+zas1sO/VnL/Qj5rPOWyFeDOGTEr/esKkTGBAWX1k7DCCsZueAYHKcv21s5fJQyJfGS1HV864sIYmwKtxz881+HYipoMowk0UbpJLmXCGQ7Fni/mA48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763948413; c=relaxed/simple;
	bh=OHInSRyjOL40BhPyMvbRdyruhQ6pHDtbODKfKnzsKV8=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=QKU/GfRZAolAnpnkpzjw9myHbY4MgY7pbcFexZ4il60Izs9igHQhf89mh1Vgl0tAKAQxIgpkbYMFTMB8MNgfZnjDJQtkyuunagTC+iUaI0ATG0paiHd4tSLCWFt0o+HfNGvVZr9K7JFiZTaEaSwqLhBHZNB6BTSck/eH8mzycJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=bbDJ6jpD; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="bbDJ6jpD"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hnm9pRQxiCRqBNWTAp9RAPNEqoXGWQJUekQPmyavL7I=;
	b=bbDJ6jpDeUZG5QVe2227oxIrO4p439oDPRvMaLZT4N5q03GC+mFYiMAhvwUWD0cFuCTT2SV0c
	m7qrS3Z7zX5DNSRPTVPU4TjSrlwpm0IN2iW07NY6FohM7elXzd//8s8R72w5i047LFe8VkNfLso
	jQ3ypNi5F3foMB29Y4R/asM=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dF7kj6kgpz1T4Jf;
	Mon, 24 Nov 2025 09:38:21 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 73F7F18047D;
	Mon, 24 Nov 2025 09:40:01 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 24 Nov 2025 09:39:59 +0800
Subject: Re: [PATCH v2 02/22] vfio/hisi: Convert to the get_region_info op
To: Jason Gunthorpe <jgg@nvidia.com>, Alexander Gordeev
	<agordeev@linux.ibm.com>, David Airlie <airlied@gmail.com>, Alex Williamson
	<alex.williamson@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Brett Creeley
	<brett.creeley@amd.com>, <dri-devel@lists.freedesktop.org>, Eric Auger
	<eric.auger@redhat.com>, Eric Farman <farman@linux.ibm.com>, Giovanni Cabiddu
	<giovanni.cabiddu@intel.com>, Vasily Gorbik <gor@linux.ibm.com>, Heiko
 Carstens <hca@linux.ibm.com>, <intel-gfx@lists.freedesktop.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, <kvm@vger.kernel.org>, Kirti Wankhede
	<kwankhede@nvidia.com>, <linux-s390@vger.kernel.org>, Matthew Rosato
	<mjrosato@linux.ibm.com>, Nikhil Agarwal <nikhil.agarwal@amd.com>, Nipun
 Gupta <nipun.gupta@amd.com>, Peter Oberparleiter <oberpar@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>, <qat-linux@intel.com>, Rodrigo Vivi
	<rodrigo.vivi@intel.com>, Simona Vetter <simona@ffwll.ch>, Shameer Kolothum
	<skolothumtho@nvidia.com>, Sven Schnelle <svens@linux.ibm.com>, Tvrtko
 Ursulin <tursulin@ursulin.net>, <virtualization@lists.linux.dev>, Vineeth
 Vijayan <vneethv@linux.ibm.com>, Yishai Hadas <yishaih@nvidia.com>, Zhenyu
 Wang <zhenyuw.linux@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>
CC: Kevin Tian <kevin.tian@intel.com>, <patches@lists.linux.dev>, Pranjal
 Shrivastava <praan@google.com>, Mostafa Saleh <smostafa@google.com>
References: <2-v2-2a9e24d62f1b+e10a-vfio_get_region_info_op_jgg@nvidia.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <b5ffda6e-d8e9-5f02-69b3-e9f1a0901f90@huawei.com>
Date: Mon, 24 Nov 2025 09:39:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2-v2-2a9e24d62f1b+e10a-vfio_get_region_info_op_jgg@nvidia.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/11/8 1:41, Jason Gunthorpe wrote:
> Change the function signature of hisi_acc_vfio_pci_ioctl()
> and re-indent it.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Acked-by: Pranjal Shrivastava <praan@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 57 +++++++++----------
>  1 file changed, 27 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index fde33f54e99ec5..899db4d742a010 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1324,43 +1324,39 @@ static ssize_t hisi_acc_vfio_pci_read(struct vfio_device *core_vdev,
>  	return vfio_pci_core_read(core_vdev, buf, new_count, ppos);
>  }
>  
> -static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
> -				    unsigned long arg)
> +static int hisi_acc_vfio_ioctl_get_region(struct vfio_device *core_vdev,
> +					  struct vfio_region_info __user *arg)
>  {
> -	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> -		struct vfio_pci_core_device *vdev =
> -			container_of(core_vdev, struct vfio_pci_core_device, vdev);
> -		struct pci_dev *pdev = vdev->pdev;
> -		struct vfio_region_info info;
> -		unsigned long minsz;
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct vfio_region_info info;
> +	unsigned long minsz;
>  
> -		minsz = offsetofend(struct vfio_region_info, offset);
> +	minsz = offsetofend(struct vfio_region_info, offset);
>  
> -		if (copy_from_user(&info, (void __user *)arg, minsz))
> -			return -EFAULT;
> +	if (copy_from_user(&info, arg, minsz))
> +		return -EFAULT;
>  
> -		if (info.argsz < minsz)
> -			return -EINVAL;
> +	if (info.argsz < minsz)
> +		return -EINVAL;
>  
> -		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
> -			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +	if (info.index != VFIO_PCI_BAR2_REGION_INDEX)
> +		return vfio_pci_ioctl_get_region_info(core_vdev, arg);
>  
> -			/*
> -			 * ACC VF dev BAR2 region consists of both functional
> -			 * register space and migration control register space.
> -			 * Report only the functional region to Guest.
> -			 */
> -			info.size = pci_resource_len(pdev, info.index) / 2;
> +	info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
>

Please adapt based on the latest code in the Next branch.
Code updates have already been made here.

Thanks
Longfang.

> -			info.flags = VFIO_REGION_INFO_FLAG_READ |
> -					VFIO_REGION_INFO_FLAG_WRITE |
> -					VFIO_REGION_INFO_FLAG_MMAP;
> +	/*
> +	 * ACC VF dev BAR2 region consists of both functional
> +	 * register space and migration control register space.
> +	 * Report only the functional region to Guest.
> +	 */
> +	info.size = pci_resource_len(pdev, info.index) / 2;
>  
> -			return copy_to_user((void __user *)arg, &info, minsz) ?
> -					    -EFAULT : 0;
> -		}
> -	}
> -	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +	info.flags = VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE |
> +		     VFIO_REGION_INFO_FLAG_MMAP;
> +
> +	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
>  }
>  
>  static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device *vdev)
> @@ -1557,7 +1553,8 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
>  	.release = vfio_pci_core_release_dev,
>  	.open_device = hisi_acc_vfio_pci_open_device,
>  	.close_device = hisi_acc_vfio_pci_close_device,
> -	.ioctl = hisi_acc_vfio_pci_ioctl,
> +	.ioctl = vfio_pci_core_ioctl,
> +	.get_region_info = hisi_acc_vfio_ioctl_get_region,
>  	.device_feature = vfio_pci_core_ioctl_feature,
>  	.read = hisi_acc_vfio_pci_read,
>  	.write = hisi_acc_vfio_pci_write,
> 
