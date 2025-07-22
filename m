Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC06289812
	for <patches@lists.linux.dev>; Tue, 22 Jul 2025 14:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753196355; cv=none; b=ajVTxxbgwsGKh/W9vct3nN9nnL9WfNkwT08OWOO0nykRaUp7+T82GOrGAF6ZkQ9iRKONETKUwLCU1+uTevqjkSX33v+RVxhwAVnm5QFsTZgNEwP+mpTLY+c3jwoGl62tQRq6DnEdb2YnO41gPSuBzL08bPpXh/lxasV9bvxHFbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753196355; c=relaxed/simple;
	bh=IFAsri3CcLKx0KS6+ejf7gmlRbdTaosLJeEibD3whgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j96zQR+li+HL/SgyjpsjyxIBribIJW9LFJmuXFcju7shCHiteBGEoSvDjZDeOA/8ZVbFbVCqJXIeuIdn67+PtCQl3olZkblOp+gP/Qejm9hR9UogZlCxtp3o1EpQQzWfb3UEKhCV7HaMiphCXBDVddHe5Pg7WTKDvEwAqG6uzPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=n9VO0sam; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="n9VO0sam"
Received: from [100.79.192.236] (unknown [4.194.122.162])
	by linux.microsoft.com (Postfix) with ESMTPSA id 3E1E22126895;
	Tue, 22 Jul 2025 07:59:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3E1E22126895
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1753196353;
	bh=Pz7MSkW3yMmCC8dKnm/72AX+sr/xBOFpxNYar1PPysY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n9VO0samYllWt7WDoW+UFIIA4BjJ3Og4AKVbm1chqzL3gbUh89jfTntZ8LWgjaiZR
	 FyjE+VTZM45p2Xjp72O2nTKc69nTD+2SW7GGaPd0KIg+od9AqLktUv62uPbtA9v+lL
	 dE+5XSgrfGZ/h35kfiv5TQTkg1Xp4NcDfuYQG4Wo=
Message-ID: <d9be2bb3-5f84-4182-91e8-ec1a4abd8f5f@linux.microsoft.com>
Date: Tue, 22 Jul 2025 20:29:07 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 020/158] tools/hv: fcopy: Fix irregularities with
 size of ring buffer
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Saurabh Sengar <ssengar@linux.microsoft.com>,
 Long Li <longli@microsoft.com>, Wei Liu <wei.liu@kernel.org>
References: <20250722134340.596340262@linuxfoundation.org>
 <20250722134341.490321531@linuxfoundation.org>
Content-Language: en-US
From: Naman Jain <namjain@linux.microsoft.com>
In-Reply-To: <20250722134341.490321531@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/22/2025 7:13 PM, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Naman Jain <namjain@linux.microsoft.com>
> 
> commit a4131a50d072b369bfed0b41e741c41fd8048641 upstream.
> 
> Size of ring buffer, as defined in uio_hv_generic driver, is no longer
> fixed to 16 KB. This creates a problem in fcopy, since this size was
> hardcoded. With the change in place to make ring sysfs node actually
> reflect the size of underlying ring buffer, it is safe to get the size
> of ring sysfs file and use it for ring buffer size in fcopy daemon.
> Fix the issue of disparity in ring buffer size, by making it dynamic
> in fcopy uio daemon.
> 
> Cc: stable@vger.kernel.org
> Fixes: 0315fef2aff9 ("uio_hv_generic: Align ring size to system page")
> Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
> Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
> Reviewed-by: Long Li <longli@microsoft.com>
> Link: https://lore.kernel.org/r/20250711060846.9168-1-namjain@linux.microsoft.com
> Signed-off-by: Wei Liu <wei.liu@kernel.org>
> Message-ID: <20250711060846.9168-1-namjain@linux.microsoft.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---


Hello Greg,
Please don't pick this change yet. I have shared the reason in the other 
thread:
"Re: Patch "tools/hv: fcopy: Fix irregularities with size of ring 
buffer" has been added to the 6.12-stable tree"


Pasting it here:
This patch depends on my older patch [1] which makes sure that the size
of the ring sysfs node actually reflects the underlying ring buffer
size.

[1] could not be ported on 6.12 and older kernels because of missing
dependencies [2] and [3].
With kernel change [4] being backported to 6.12 kernel, FCopy is
currently broken which I was trying to address with my patch.

Adding Thomas as well if its possible to port these patches on older
kernels.

However for 6.6 and older kernels, fcopy is not working for me even 
without [4], which I am trying to debug.

------------
[1]
65995e97a1ca ("Drivers: hv: Make the sysfs node size for the ring buffer 
dynamic")

[2]
0afcee132bbc ("sysfs: explicitly pass size to sysfs_add_bin_file_mode_ns()")

[3]
bebf29b18f34 ("sysfs: introduce callback attribute_group::bin_size")

[4]
0315fef2aff9 ("uio_hv_generic: Align ring size to system page")

Regards,
Naman


>   tools/hv/hv_fcopy_uio_daemon.c |   91 ++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 81 insertions(+), 10 deletions(-)
> 
> --- a/tools/hv/hv_fcopy_uio_daemon.c
> +++ b/tools/hv/hv_fcopy_uio_daemon.c
> @@ -35,7 +35,10 @@
>   #define WIN8_SRV_MINOR		1
>   #define WIN8_SRV_VERSION	(WIN8_SRV_MAJOR << 16 | WIN8_SRV_MINOR)
>   
> -#define FCOPY_UIO		"/sys/bus/vmbus/devices/eb765408-105f-49b6-b4aa-c123b64d17d4/uio"
> +#define FCOPY_DEVICE_PATH(subdir) \
> +	"/sys/bus/vmbus/devices/eb765408-105f-49b6-b4aa-c123b64d17d4/" #subdir
> +#define FCOPY_UIO_PATH          FCOPY_DEVICE_PATH(uio)
> +#define FCOPY_CHANNELS_PATH     FCOPY_DEVICE_PATH(channels)
>   
>   #define FCOPY_VER_COUNT		1
>   static const int fcopy_versions[] = {
> @@ -47,9 +50,62 @@ static const int fw_versions[] = {
>   	UTIL_FW_VERSION
>   };
>   
> -#define HV_RING_SIZE		0x4000 /* 16KB ring buffer size */
> +static uint32_t get_ring_buffer_size(void)
> +{
> +	char ring_path[PATH_MAX];
> +	DIR *dir;
> +	struct dirent *entry;
> +	struct stat st;
> +	uint32_t ring_size = 0;
> +	int retry_count = 0;
>   
> -static unsigned char desc[HV_RING_SIZE];
> +	/* Find the channel directory */
> +	dir = opendir(FCOPY_CHANNELS_PATH);
> +	if (!dir) {
> +		usleep(100 * 1000); /* Avoid race with kernel, wait 100ms and retry once */
> +		dir = opendir(FCOPY_CHANNELS_PATH);
> +		if (!dir) {
> +			syslog(LOG_ERR, "Failed to open channels directory: %s", strerror(errno));
> +			return 0;
> +		}
> +	}
> +
> +retry_once:
> +	while ((entry = readdir(dir)) != NULL) {
> +		if (entry->d_type == DT_DIR && strcmp(entry->d_name, ".") != 0 &&
> +		    strcmp(entry->d_name, "..") != 0) {
> +			snprintf(ring_path, sizeof(ring_path), "%s/%s/ring",
> +				 FCOPY_CHANNELS_PATH, entry->d_name);
> +
> +			if (stat(ring_path, &st) == 0) {
> +				/*
> +				 * stat returns size of Tx, Rx rings combined,
> +				 * so take half of it for individual ring size.
> +				 */
> +				ring_size = (uint32_t)st.st_size / 2;
> +				syslog(LOG_INFO, "Ring buffer size from %s: %u bytes",
> +				       ring_path, ring_size);
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (!ring_size && retry_count == 0) {
> +		retry_count = 1;
> +		rewinddir(dir);
> +		usleep(100 * 1000); /* Wait 100ms and retry once */
> +		goto retry_once;
> +	}
> +
> +	closedir(dir);
> +
> +	if (!ring_size)
> +		syslog(LOG_ERR, "Could not determine ring size");
> +
> +	return ring_size;
> +}
> +
> +static unsigned char *desc;
>   
>   static int target_fd;
>   static char target_fname[PATH_MAX];
> @@ -406,7 +462,7 @@ int main(int argc, char *argv[])
>   	int daemonize = 1, long_index = 0, opt, ret = -EINVAL;
>   	struct vmbus_br txbr, rxbr;
>   	void *ring;
> -	uint32_t len = HV_RING_SIZE;
> +	uint32_t ring_size, len;
>   	char uio_name[NAME_MAX] = {0};
>   	char uio_dev_path[PATH_MAX] = {0};
>   
> @@ -437,7 +493,20 @@ int main(int argc, char *argv[])
>   	openlog("HV_UIO_FCOPY", 0, LOG_USER);
>   	syslog(LOG_INFO, "starting; pid is:%d", getpid());
>   
> -	fcopy_get_first_folder(FCOPY_UIO, uio_name);
> +	ring_size = get_ring_buffer_size();
> +	if (!ring_size) {
> +		ret = -ENODEV;
> +		goto exit;
> +	}
> +
> +	desc = malloc(ring_size * sizeof(unsigned char));
> +	if (!desc) {
> +		syslog(LOG_ERR, "malloc failed for desc buffer");
> +		ret = -ENOMEM;
> +		goto exit;
> +	}
> +
> +	fcopy_get_first_folder(FCOPY_UIO_PATH, uio_name);
>   	snprintf(uio_dev_path, sizeof(uio_dev_path), "/dev/%s", uio_name);
>   	fcopy_fd = open(uio_dev_path, O_RDWR);
>   
> @@ -445,17 +514,17 @@ int main(int argc, char *argv[])
>   		syslog(LOG_ERR, "open %s failed; error: %d %s",
>   		       uio_dev_path, errno, strerror(errno));
>   		ret = fcopy_fd;
> -		goto exit;
> +		goto free_desc;
>   	}
>   
> -	ring = vmbus_uio_map(&fcopy_fd, HV_RING_SIZE);
> +	ring = vmbus_uio_map(&fcopy_fd, ring_size);
>   	if (!ring) {
>   		ret = errno;
>   		syslog(LOG_ERR, "mmap ringbuffer failed; error: %d %s", ret, strerror(ret));
>   		goto close;
>   	}
> -	vmbus_br_setup(&txbr, ring, HV_RING_SIZE);
> -	vmbus_br_setup(&rxbr, (char *)ring + HV_RING_SIZE, HV_RING_SIZE);
> +	vmbus_br_setup(&txbr, ring, ring_size);
> +	vmbus_br_setup(&rxbr, (char *)ring + ring_size, ring_size);
>   
>   	rxbr.vbr->imask = 0;
>   
> @@ -470,7 +539,7 @@ int main(int argc, char *argv[])
>   			continue;
>   		}
>   
> -		len = HV_RING_SIZE;
> +		len = ring_size;
>   		ret = rte_vmbus_chan_recv_raw(&rxbr, desc, &len);
>   		if (unlikely(ret <= 0)) {
>   			/* This indicates a failure to communicate (or worse) */
> @@ -490,6 +559,8 @@ int main(int argc, char *argv[])
>   	}
>   close:
>   	close(fcopy_fd);
> +free_desc:
> +	free(desc);
>   exit:
>   	return ret;
>   }
> 

