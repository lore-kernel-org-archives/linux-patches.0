Received: from out198-158.us.a.mail.aliyun.com (out198-158.us.a.mail.aliyun.com [47.90.198.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3AB4AA1CE
	for <patches@lists.linux.dev>; Sun, 18 Oct 2026 14:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792333430; cv=none; b=Ro2GCaRX/gRIFVdgQl9loq7E82/2j8aplqO6vjLOy/rah9mjd/KyYyB1Z1ri+IAsPPVdDZe9trYH7mGTepsQEOU/BiDzSFEzE1TTKYiLcVZXqE0KOKnG7nw82h0fhyPTb8Dg3Ttyihb//bO47xp/A/SPEeAhGRFSeapsbGTvX2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792333430; c=relaxed/simple;
	bh=iwrG2CF5CQKCjpu/K5joC/BAqpZ90MdR78mFcfVqEqU=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=ixSkaN1VEhwxjVaj1zbIH1IldzzjsHHD0isCLz7Yi0hal2YQfvf7vaqbow13Yxl/25Nuxv3pqZfPezhKD5wE6h+zH6OT5Srl7xLau/z8oQ87QrmB/iVHqrdzTM4H4AcRPliKmXq7txxKuljyc6BJ7suub4/9invRIFVYZ9XbzVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=47.90.198.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.04436514|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.131031-0.000425844-0.868543;FP=15510668704860441811|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037026024;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=8;RT=8;SR=0;TI=SMTPD_---.jj7kr-7_1792329738;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.jj7kr-7_1792329738 cluster:ay29)
          by smtp.aliyun-inc.com;
          Sun, 18 Oct 2026 21:22:19 +0800
Date: Sun, 18 Oct 2026 21:22:20 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.12 543/869] perf tools: Use perf_env__get_cpu_topology() in machine__resolve()
Cc: stable@vger.kernel.org,
 patches@lists.linux.dev,
 sashiko-bot <sashiko-bot@kernel.org>,
 Ian Rogers <irogers@google.com>,
 Kan Liang <kan.liang@intel.com>,
 Arnaldo Carvalho de Melo <acme@redhat.com>,
 Sasha Levin <sashal@kernel.org>
In-Reply-To: <20261017160051.014967079@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org> <20261017160051.014967079@linuxfoundation.org>
Message-Id: <20261018212219.A23A.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.83.03 [en]

Hi,

please drop this patch for 6.12.y or add some dependency.

because of the build error:
util/event.c:775:32: error: implicit declaration of function ¡®perf_env__get_cpu_topology¡¯; did you mean ¡®perf_env__read_cpu_topology_map¡¯? [-Wimplicit-function-declaration]

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2026/10/18

> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> [ Upstream commit 5484b43a0ec8231c36fba6ead654cb72dbba8b8f ]
> 
> machine__resolve() accesses env->cpu[al->cpu].socket_id after checking
> al->cpu >= 0 and env->cpu != NULL, but without validating al->cpu
> against env->nr_cpus_avail.  Since al->cpu comes from the untrusted
> perf.data sample, a crafted file with a large CPU index causes an
> out-of-bounds heap read.
> 
> Use perf_env__get_cpu_topology() which validates both NULL and bounds.
> Also bounds-check al->cpu before the cast to struct perf_cpu (int16_t):
> without this, values like 65536 silently truncate to 0, bypassing the
> accessor's internal check and returning CPU 0's topology.
> 
> Fixes: 0c4c4debb0adda4c ("perf tools: Add processor socket info to hist_entry and addr_location")
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Reviewed-by: Ian Rogers <irogers@google.com>
> Cc: Kan Liang <kan.liang@intel.com>
> Cc: Ian Rogers <irogers@google.com>
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/perf/util/event.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index aac96d5d19170..1e5085817e825 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -12,6 +12,7 @@
>  #include <linux/zalloc.h>
>  #include "cpumap.h"
>  #include "dso.h"
> +#include "env.h"
>  #include "event.h"
>  #include "debug.h"
>  #include "hist.h"
> @@ -763,8 +764,18 @@ int machine__resolve(struct machine *machine, struct addr_location *al,
>  	if (al->cpu >= 0) {
>  		struct perf_env *env = machine->env;
>  
> -		if (env && env->cpu)
> -			al->socket = env->cpu[al->cpu].socket_id;
> +		/*
> +		 * Bounds-check al->cpu (s32) before casting to struct perf_cpu
> +		 * (int16_t): without this, e.g. 65536 truncates to 0 and silently
> +		 * returns CPU 0's topology.  Can go once perf_cpu.cpu is widened.
> +		 */
> +		if (env && al->cpu < env->nr_cpus_avail) {
> +			struct cpu_topology_map *topo;
> +
> +			topo = perf_env__get_cpu_topology(env, (struct perf_cpu){ al->cpu });
> +			if (topo)
> +				al->socket = topo->socket_id;
> +		}
>  	}
>  
>  	if (al->map) {
> -- 
> 2.53.0
> 
> 
> 
> 


