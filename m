Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE9759443
	for <patches@lists.linux.dev>; Tue, 28 Feb 2023 17:12:32 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5961AC14;
	Tue, 28 Feb 2023 09:13:15 -0800 (PST)
Received: from [10.1.196.177] (eglon.cambridge.arm.com [10.1.196.177])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0938D3F881;
	Tue, 28 Feb 2023 09:12:28 -0800 (PST)
Message-ID: <ed707884-aa1f-fa28-63bf-ad5d87230893@arm.com>
Date: Tue, 28 Feb 2023 17:12:23 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 0/7] x86/resctrl: Add support for Sub-NUMA cluster (SNC)
 systems
Content-Language: en-GB
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Peter Newman <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
 x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
 Jamie Iles <quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 patches@lists.linux.dev
References: <20230126184157.27626-1-tony.luck@intel.com>
From: James Morse <james.morse@arm.com>
In-Reply-To: <20230126184157.27626-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Tony,

On 26/01/2023 18:41, Tony Luck wrote:
> Intel server systems starting with Skylake support a mode that logically
> partitions each socket. E.g. when partitioned two ways, half the cores,
> L3 cache, and memory controllers are allocated to each of the partitions.
> This may reduce average latency to access L3 cache and memory, with the
> tradeoff that only half the L3 cache is available for subnode-local memory
> access.

I couldn't find a description of what happens to the CAT bitmaps or counters.

Presumably the CAT bitmaps are duplicated, so each cluster has its own set, and
the counters aren't - so software has to co-ordinate the use of RMID across the CPUs?


How come cacheinfo isn't modified to report the L3 partitions as separate caches?
Otherwise user-space would assume the full size of the cache is available on any of those
CPUs.
This would avoid an ABI change in resctrl (domain is now the numa node), leaving only the
RMID range code.


Thanks,

James
