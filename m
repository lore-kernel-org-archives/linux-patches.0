Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849021F03DD;
	Wed,  4 Dec 2024 17:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733334225; cv=none; b=b09BwmGcc3+2MsKxk8YfZy1s5BtW6PzAz5+SRqAO/wlw6bI/o4dksfHUfXqToOPdxeqXzF6hHiZI8HqRetp4S1UreBup0hkrPWZWLSdDMLHGW99PLlWP4GyF0H/AQmPYwzra7bUyRznHFLjyCl+xpd87cSK40jvTs55VXEw48yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733334225; c=relaxed/simple;
	bh=6dslxSEtvc/+AI8wCFo+U7QVaW/wNEfNh8DyXFqZuCw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=bxbjgGsu6inQAd9S4mEF9TiRjt4zbbZuDpBn954BlcXMJFlHqWUOP70lb7PkhN2Fb7cMBSNN9o94rcrEwuc8caRRQyB/A/6mSkVXiZSWKW+A3tqfqANoQnxVIolHr4FRgMV2I1t0T2fyJS7g85aKxhOmNJgRsdvyOVGcnca9KbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=FdVXOyoe; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="FdVXOyoe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:References:Cc:To:From:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=BG31DdiJ2Iz7TXZTm9hVg92l826j8PxwKF9YEXyaLvg=; t=1733334222;
	x=1733766222; b=FdVXOyoe+U5i10HlVpucFJOYXpKi++GR8OSljhy/pne6qQLsii1l6XctIkJgH
	JSaRGJXF2DWrq7VP1PFsbW2345g/UUVn5QaEx1RyYJLb7GyBfqu/jL9Enxr35rYxDZZtOGmZgYWpi
	AwPt+3BCVSgdLW15h66TAxBmkjrcw/VEc6T1DCrZ6bEw7TYWsoYeYm5r7XKwgJJRY/QDHH9L9cJG/
	bADlRZ9u92Itj60MTv2QSJiQXTGq7JbWORA8Px/OVyJQM74ZwajUPjwJv147CeAMP/ZNA9QbYmsQ3
	4/2xY8dJ0cQ7Tf/mi9/xP+QpqWLyZSTL1SjiRAK5S+eHeDl5xw==;
Received: from [2a02:8108:8980:2478:87e9:6c79:5f84:367d]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	id 1tItPK-00DEZe-20;
	Wed, 04 Dec 2024 18:43:26 +0100
Message-ID: <563836eb-78da-4a89-b80a-52775107161d@leemhuis.info>
Date: Wed, 4 Dec 2024 18:43:24 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 470/826] perf stat: Uniquify event name improvements
From: Thorsten Leemhuis <linux@leemhuis.info>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
 Ian Rogers <irogers@google.com>, Kan Liang <kan.liang@linux.intel.com>,
 James Clark <james.clark@linaro.org>, Yang Jihong
 <yangjihong@bytedance.com>, Dominique Martinet <asmadeus@codewreck.org>,
 Colin Ian King <colin.i.king@gmail.com>, Howard Chu <howardchu95@gmail.com>,
 Ze Gao <zegao2021@gmail.com>, Yicong Yang <yangyicong@hisilicon.com>,
 Weilin Wang <weilin.wang@intel.com>, Will Deacon <will@kernel.org>,
 Mike Leach <mike.leach@linaro.org>, Jing Zhang <renyu.zj@linux.alibaba.com>,
 Yang Li <yang.lee@linux.alibaba.com>, Leo Yan <leo.yan@linux.dev>,
 ak@linux.intel.com, Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Sun Haiyong <sunhaiyong@loongson.cn>,
 John Garry <john.g.garry@oracle.com>,
 Justin Forbes <jforbes@fedoraproject.org>,
 Naresh Kamboju <naresh.kamboju@linaro.org>,
 Florian Fainelli <f.fainelli@gmail.com>
References: <20241203144743.428732212@linuxfoundation.org>
 <20241203144802.097952233@linuxfoundation.org>
 <f2ada8a7-165b-41fb-8b7b-3c0d16bb8216@leemhuis.info>
Content-Language: en-MW
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 n7RI
In-Reply-To: <f2ada8a7-165b-41fb-8b7b-3c0d16bb8216@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1733334222;fa4d9103;
X-HE-SMSGID: 1tItPK-00DEZe-20

On 03.12.24 18:24, Thorsten Leemhuis wrote:
> On 03.12.24 15:43, Greg Kroah-Hartman wrote:
>> 6.12-stable review patch.  If anyone has any objections, please let me=
 know.
>>
>> ------------------
>>
>> From: Ian Rogers <irogers@google.com>
>>
>> [ Upstream commit 057f8bfc6f7070577523d1e3081081bbf4229c1c ]
>>
>> Without aggregation on Intel:
>=20
> My 6.11.y-rc and 6.12.y-rc builds for Fedora failed when building perf.=
=20
> I did not bisect, but from a brief look at the error message (see
> below) I suspect it might be caused by this patch, which is the
> second of the patch-set "Event parsing fixes":
> https://lore.kernel.org/all/20240926144851.245903-1-james.clark@linaro.=
org/

TWIMC, Florian Fainelli and Naresh Kamboju (both now CCed) meanwhile
reported the same problem for the latest 6.11.y and 6.12.y rc releases:

https://lore.kernel.org/all/5eeb1f9c-2b9f-49f1-9861-051478a8630d@gmail.co=
m/
https://lore.kernel.org/all/713b5871-c7a3-44fa-a5ac-5cf558be81c9@gmail.co=
m/
https://lore.kernel.org/all/CA+G9fYu21yqTvL428TFueMJ1uU1H_u8Vc470dER2CTrN=
K=3DJs0g@mail.gmail.com/
https://lore.kernel.org/all/CA+G9fYtNvEDcUEuv=3DQFC84y+pXY1UszoRYOitJztCA=
pLV7-psg@mail.gmail.com/

Ciao, Thorsten

> To my untrained eyes and from a quick look I guess the first patch
> in the series needs to be backported as well:
> perf evsel: Add alternate_hw_config and use in evsel__match
> https://lore.kernel.org/all/20240926144851.245903-2-james.clark@linaro.=
org/
>=20
> This is 22a4db3c36034e ("perf evsel: Add alternate_hw_config
> and use in evsel__match") in mainline. I tried to cherry-pick it
> on-top of 6.12.2-rc1, but there were a few small conflicts.=20
>=20
> Ciao, Thorsten
>=20
> P.S.: The build error:
>=20
>   gcc -Wp,-MD,util/.topdown.o.d -Wp,-MT,util/topdown.o -O2 -fexceptions=
 -g -grecord-gcc-switches -pipe -Wall -Wno-complain-wrong-lang -Werror=3D=
format-security -Wp,-U_FORTIFY_SOURCE,-D_FORTIFY_SOURCE=3D3 -Wp,-D_GLIBCX=
X_ASSERTIONS -specs=3D/usr/lib/rpm/redhat/redhat-hardened-cc1 -fstack-pro=
tector-strong -specs=3D/usr/lib/rpm/redhat/redhat-annobin-cc1 -m64 -march=
=3Dx86-64 -mtune=3Dgeneric -fasynchronous-unwind-tables -fstack-clash-pro=
tection -fcf-protection -mtls-dialect=3Dgnu2 -Wbad-function-cast -Wdeclar=
ation-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissin=
g-declarations -Wmissing-prototypes -Wno-system-headers -Wold-style-defin=
ition -Wpacked -Wredundant-decls -Wstrict-prototypes -Wswitch-default -Ws=
witch-enum -Wundef -Wwrite-strings -Wformat -Wno-type-limits -Wstrict-ali=
asing=3D3 -Wshadow -DHAVE_SYSCALL_TABLE_SUPPORT -Iarch/x86/include/genera=
ted -DHAVE_ARCH_X86_64_SUPPORT -DHAVE_ARCH_REGS_QUERY_REGISTER_OFFSET -DN=
DEBUG=3D1 -O3 -fno-omit-frame-pointer -Wall -Wextra -std=3Dgnu11 -fstack-=
protector-all -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=3D2 -D_LARGEFILE64_SOUR=
CE -D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE -I/builddir/build/BUILD/kernel-=
6.12.2-build/kernel-6.12.2-rc1/linux-6.12.2-0.rc1.400.vanilla.fc41.x86_64=
/tools/perf/util/include -I/builddir/build/BUILD/kernel-6.12.2-build/kern=
el-6.12.2-rc1/linux-6.12.2-0.rc1.400.vanilla.fc41.x86_64/tools/perf/arch/=
x86/include -I/builddir/build/BUILD/kernel-6.12.2-build/kernel-6.12.2-rc1=
/linux-6.12.2-0.rc1.400.vanilla.fc41.x86_64/tools/include/ -I/builddir/bu=
ild/BUILD/kernel-6.12.2-build/kernel-6.12.2-rc1/linux-6.12.2-0.rc1.400.va=
nilla.fc41.x86_64/tools/arch/x86/include/uapi -I/builddir/build/BUILD/ker=
nel-6.12.2-build/kernel-6.12.2-rc1/linux-6.12.2-0.rc1.400.vanilla.fc41.x8=
6_64/tools/include/uapi -I/builddir/build/BUILD/kernel-6.12.2-build/kerne=
l-6.12.2-rc1/linux-6.12.2-0.rc1.400.vanilla.fc41.x86_64/tools/arch/x86/in=
clude/ -I/builddir/build/BUILD/kernel-6.12.2-build/kernel-6.12.2-rc1/linu=
x-6.12.2-0.rc1.400.vanilla.fc41.x86_64/tools/arch/x86/ -I/builddir/build/=
BUILD/kernel-6.12.2-build/kernel-6.12.2-rc1/linux-6.12.2-0.rc1.400.vanill=
a.fc41.x86_64/tools/perf/util -I/builddir/build/BUILD/kernel-6.12.2-build=
/kernel-6.12.2-rc1/linux-6.12.2-0.rc1.400.vanilla.fc41.x86_64/tools/perf =
-DHAVE_PTHREAD_ATTR_SETAFFINITY_NP -DHAVE_PTHREAD_BARRIER -DHAVE_EVENTFD_=
SUPPORT -DHAVE_GET_CURRENT_DIR_NAME -DHAVE_GETTID -DHAVE_FILE_HANDLE -DHA=
VE_DWARF_GETLOCATIONS_SUPPORT -DHAVE_DWARF_CFI_SUPPORT -DHAVE_AIO_SUPPORT=
 -DHAVE_SCANDIRAT_SUPPORT -DHAVE_SCHED_GETCPU_SUPPORT -DHAVE_SETNS_SUPPOR=
T -DHAVE_ZLIB_SUPPORT -DHAVE_LIBELF_SUPPORT -DHAVE_ELF_GETPHDRNUM_SUPPORT=
 -DHAVE_GELF_GETNOTE_SUPPORT -DHAVE_ELF_GETSHDRSTRNDX_SUPPORT -DHAVE_DWAR=
F_SUPPORT -DHAVE_LIBBPF_SUPPORT -DHAVE_SDT_EVENT -DHAVE_JITDUMP -DHAVE_BP=
F_SKEL -DHAVE_DWARF_UNWIND_SUPPORT -DHAVE_LIBCRYPTO_SUPPORT -DHAVE_SLANG_=
SUPPORT -DHAVE_LIBPERL_SUPPORT -DHAVE_TIMERFD_SUPPORT -DHAVE_LIBPYTHON_SU=
PPORT -fPIC -DHAVE_LIBLLVM_SUPPORT -I/usr/include -D_GNU_SOURCE -D__STDC_=
CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -DHAVE_CXA_D=
EMANGLE_SUPPORT -DHAVE_LZMA_SUPPORT -DHAVE_ZSTD_SUPPORT -DHAVE_BACKTRACE_=
SUPPORT -DHAVE_LIBNUMA_SUPPORT -DHAVE_KVM_STAT_SUPPORT -DDISASM_FOUR_ARGS=
_SIGNATURE -DDISASM_INIT_STYLED -DHAVE_LIBBABELTRACE_SUPPORT -DHAVE_AUXTR=
ACE_SUPPORT -DHAVE_JVMTI_CMLR -DHAVE_LIBTRACEEVENT -I/usr/include/traceev=
ent -DLIBTRACEEVENT_VERSION=3D67067 -I/usr/include/tracefs -I/usr/include=
/traceevent -DLIBTRACEFS_VERSION=3D67065 -I/builddir/build/BUILD/kernel-6=
=2E12.2-build/kernel-6.12.2-rc1/linux-6.12.2-0.rc1.400.vanilla.fc41.x86_6=
4/tools/perf/libapi/include -I/builddir/build/BUILD/kernel-6.12.2-build/k=
ernel-6.12.2-rc1/linux-6.12.2-0.rc1.400.vanilla.fc41.x86_64/tools/perf/li=
bsubcmd/include -I/builddir/build/BUILD/kernel-6.12.2-build/kernel-6.12.2=
-rc1/linux-6.12.2-0.rc1.400.vanilla.fc41.x86_64/tools/perf/libsymbol/incl=
ude -I/builddir/build/BUILD/kernel-6.12.2-build/kernel-6.12.2-rc1/linux-6=
=2E12.2-0.rc1.400.vanilla.fc41.x86_64/tools/perf/libperf/include -D"BUILD=
_STR(s)=3D#s" -c -o util/topdown.o util/topdown.c
> util/stat-display.c: In function =E2=80=98uniquify_event_name=E2=80=99:=

> util/stat-display.c:895:45: error: =E2=80=98struct evsel=E2=80=99 has n=
o member named =E2=80=98alternate_hw_config=E2=80=99
>   895 |         if (counter->pmu->is_core && counter->alternate_hw_conf=
ig !=3D PERF_COUNT_HW_MAX)
>       |                                             ^~
> make[4]: *** [/builddir/build/BUILD/kernel-6.12.2-build/kernel-6.12.2-r=
c1/linux-6.12.2-0.rc1.400.vanilla.fc41.x86_64/tools/build/Makefile.build:=
106: util/stat-display.o] Error 1
> make[4]: *** Waiting for unfinished jobs....
>=20
>> ```
>> $ perf stat -e instructions,cycles ...
>> ```
>> Will use "cycles" for the name of the legacy cycles event but as
>> "instructions" has a sysfs name it will and a "[cpu]" PMU suffix. This=

>> often breaks things as the space between the event and the PMU name
>> look like an extra column. The existing uniquify logic was also
>> uniquifying in cases when all events are core and not with uncore
>> events, it was not correctly handling modifiers, etc.
>>
>> Change the logic so that an initial pass that can disable
>> uniquification is run. For individual counters, disable uniquification=

>> in more cases such as for consistency with legacy events or for
>> libpfm4 events. Don't use the "[pmu]" style suffix in uniquification,
>> always use "pmu/.../". Change how modifiers/terms are handled in the
>> uniquification so that they look like parse-able events.
>>
>> This fixes "102: perf stat metrics (shadow stat) test:" that has been
>> failing due to "instructions [cpu]" breaking its column/awk logic when=

>> values aren't aggregated. This started happening when instructions
>> could match a sysfs rather than a legacy event, so the fixes tag
>> reflects this.
>>
>> Fixes: 617824a7f0f7 ("perf parse-events: Prefer sysfs/JSON hardware ev=
ents over legacy")
>> Acked-by: Namhyung Kim <namhyung@kernel.org>
>> Signed-off-by: Ian Rogers <irogers@google.com>
>> [ Fix Intel TPEBS counting mode test ]
>> Acked-by: Kan Liang <kan.liang@linux.intel.com>
>> Signed-off-by: James Clark <james.clark@linaro.org>
>> Cc: Yang Jihong <yangjihong@bytedance.com>
>> Cc: Dominique Martinet <asmadeus@codewreck.org>
>> Cc: Colin Ian King <colin.i.king@gmail.com>
>> Cc: Howard Chu <howardchu95@gmail.com>
>> Cc: Ze Gao <zegao2021@gmail.com>
>> Cc: Yicong Yang <yangyicong@hisilicon.com>
>> Cc: Weilin Wang <weilin.wang@intel.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Mike Leach <mike.leach@linaro.org>
>> Cc: Jing Zhang <renyu.zj@linux.alibaba.com>
>> Cc: Yang Li <yang.lee@linux.alibaba.com>
>> Cc: Leo Yan <leo.yan@linux.dev>
>> Cc: ak@linux.intel.com
>> Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: Sun Haiyong <sunhaiyong@loongson.cn>
>> Cc: John Garry <john.g.garry@oracle.com>
>> Link: https://lore.kernel.org/r/20240926144851.245903-3-james.clark@li=
naro.org
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  .../perf/tests/shell/test_stat_intel_tpebs.sh |  11 +-
>>  tools/perf/util/stat-display.c                | 101 ++++++++++++++---=
-
>>  2 files changed, 85 insertions(+), 27 deletions(-)
>>
>> diff --git a/tools/perf/tests/shell/test_stat_intel_tpebs.sh b/tools/p=
erf/tests/shell/test_stat_intel_tpebs.sh
>> index c60b29add9801..9a11f42d153ca 100755
>> --- a/tools/perf/tests/shell/test_stat_intel_tpebs.sh
>> +++ b/tools/perf/tests/shell/test_stat_intel_tpebs.sh
>> @@ -8,12 +8,15 @@ grep -q GenuineIntel /proc/cpuinfo || { echo Skippin=
g non-Intel; exit 2; }
>>  # Use this event for testing because it should exist in all platforms=

>>  event=3Dcache-misses:R
>> =20
>> +# Hybrid platforms output like "cpu_atom/cache-misses/R", rather than=
 as above
>> +alt_name=3D/cache-misses/R
>> +
>>  # Without this cmd option, default value or zero is returned
>> -echo "Testing without --record-tpebs"
>> -result=3D$(perf stat -e "$event" true 2>&1)
>> -[[ "$result" =3D~ $event ]] || exit 1
>> +#echo "Testing without --record-tpebs"
>> +#result=3D$(perf stat -e "$event" true 2>&1)
>> +#[[ "$result" =3D~ $event || "$result" =3D~ $alt_name ]] || exit 1
>> =20
>>  # In platforms that do not support TPEBS, it should execute without e=
rror.
>>  echo "Testing with --record-tpebs"
>>  result=3D$(perf stat -e "$event" --record-tpebs -a sleep 0.01 2>&1)
>> -[[ "$result" =3D~ "perf record" && "$result" =3D~ $event ]] || exit 1=

>> +[[ "$result" =3D~ "perf record" && "$result" =3D~ $event || "$result"=
 =3D~ $alt_name ]] || exit 1
>> diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-dis=
play.c
>> index ea96e4ebad8c8..cbff43ff8d0fb 100644
>> --- a/tools/perf/util/stat-display.c
>> +++ b/tools/perf/util/stat-display.c
>> @@ -871,38 +871,66 @@ static void printout(struct perf_stat_config *co=
nfig, struct outstate *os,
>> =20
>>  static void uniquify_event_name(struct evsel *counter)
>>  {
>> -	char *new_name;
>> -	char *config;
>> -	int ret =3D 0;
>> +	const char *name, *pmu_name;
>> +	char *new_name, *config;
>> +	int ret;
>> =20
>> -	if (counter->uniquified_name || counter->use_config_name ||
>> -	    !counter->pmu_name || !strncmp(evsel__name(counter), counter->pm=
u_name,
>> -					   strlen(counter->pmu_name)))
>> +	/* The evsel was already uniquified. */
>> +	if (counter->uniquified_name)
>>  		return;
>> =20
>> -	config =3D strchr(counter->name, '/');
>> +	/* Avoid checking to uniquify twice. */
>> +	counter->uniquified_name =3D true;
>> +
>> +	/* The evsel has a "name=3D" config term or is from libpfm. */
>> +	if (counter->use_config_name || counter->is_libpfm_event)
>> +		return;
>> +
>> +	/* Legacy no PMU event, don't uniquify. */
>> +	if  (!counter->pmu ||
>> +	     (counter->pmu->type < PERF_TYPE_MAX && counter->pmu->type !=3D =
PERF_TYPE_RAW))
>> +		return;
>> +
>> +	/* A sysfs or json event replacing a legacy event, don't uniquify. *=
/
>> +	if (counter->pmu->is_core && counter->alternate_hw_config !=3D PERF_=
COUNT_HW_MAX)
>> +		return;
>> +
>> +	name =3D evsel__name(counter);
>> +	pmu_name =3D counter->pmu->name;
>> +	/* Already prefixed by the PMU name. */
>> +	if (!strncmp(name, pmu_name, strlen(pmu_name)))
>> +		return;
>> +
>> +	config =3D strchr(name, '/');
>>  	if (config) {
>> -		if (asprintf(&new_name,
>> -			     "%s%s", counter->pmu_name, config) > 0) {
>> -			free(counter->name);
>> -			counter->name =3D new_name;
>> -		}
>> -	} else {
>> -		if (evsel__is_hybrid(counter)) {
>> -			ret =3D asprintf(&new_name, "%s/%s/",
>> -				       counter->pmu_name, counter->name);
>> +		int len =3D config - name;
>> +
>> +		if (config[1] =3D=3D '/') {
>> +			/* case: event// */
>> +			ret =3D asprintf(&new_name, "%s/%.*s/%s", pmu_name, len, name, con=
fig + 2);
>>  		} else {
>> -			ret =3D asprintf(&new_name, "%s [%s]",
>> -				       counter->name, counter->pmu_name);
>> +			/* case: event/.../ */
>> +			ret =3D asprintf(&new_name, "%s/%.*s,%s", pmu_name, len, name, con=
fig + 1);
>>  		}
>> +	} else {
>> +		config =3D strchr(name, ':');
>> +		if (config) {
>> +			/* case: event:.. */
>> +			int len =3D config - name;
>> =20
>> -		if (ret) {
>> -			free(counter->name);
>> -			counter->name =3D new_name;
>> +			ret =3D asprintf(&new_name, "%s/%.*s/%s", pmu_name, len, name, con=
fig + 1);
>> +		} else {
>> +			/* case: event */
>> +			ret =3D asprintf(&new_name, "%s/%s/", pmu_name, name);
>>  		}
>>  	}
>> -
>> -	counter->uniquified_name =3D true;
>> +	if (ret > 0) {
>> +		free(counter->name);
>> +		counter->name =3D new_name;
>> +	} else {
>> +		/* ENOMEM from asprintf. */
>> +		counter->uniquified_name =3D false;
>> +	}
>>  }
>> =20
>>  static bool hybrid_uniquify(struct evsel *evsel, struct perf_stat_con=
fig *config)
>> @@ -1559,6 +1587,31 @@ static void print_cgroup_counter(struct perf_st=
at_config *config, struct evlist
>>  		print_metric_end(config, os);
>>  }
>> =20
>> +static void disable_uniquify(struct evlist *evlist)
>> +{
>> +	struct evsel *counter;
>> +	struct perf_pmu *last_pmu =3D NULL;
>> +	bool first =3D true;
>> +
>> +	evlist__for_each_entry(evlist, counter) {
>> +		/* If PMUs vary then uniquify can be useful. */
>> +		if (!first && counter->pmu !=3D last_pmu)
>> +			return;
>> +		first =3D false;
>> +		if (counter->pmu) {
>> +			/* Allow uniquify for uncore PMUs. */
>> +			if (!counter->pmu->is_core)
>> +				return;
>> +			/* Keep hybrid event names uniquified for clarity. */
>> +			if (perf_pmus__num_core_pmus() > 1)
>> +				return;
>> +		}
>> +	}
>> +	evlist__for_each_entry_continue(evlist, counter) {
>> +		counter->uniquified_name =3D true;
>> +	}
>> +}
>> +
>>  void evlist__print_counters(struct evlist *evlist, struct perf_stat_c=
onfig *config,
>>  			    struct target *_target, struct timespec *ts,
>>  			    int argc, const char **argv)
>> @@ -1572,6 +1625,8 @@ void evlist__print_counters(struct evlist *evlis=
t, struct perf_stat_config *conf
>>  		.first =3D true,
>>  	};
>> =20
>> +	disable_uniquify(evlist);
>> +
>>  	if (config->iostat_run)
>>  		evlist->selected =3D evlist__first(evlist);
>> =20
>=20

