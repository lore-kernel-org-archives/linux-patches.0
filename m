Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EF715E8B;
	Mon, 30 Dec 2024 15:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574300; cv=none; b=hkRTg6/GW/Ijw9VqiOZEKbsz4i6zZ90xbAtGkTvKl8KZPvxXxrTrVYRkn+tG8HGQhwTkMwncR50Dbn5sYBIIWhsp9G0WesjfCrj6bljJMIFRZzGZMGpXxSrCXSD342YSBZQqsxYHs1EkSHghXMDoKYhXbphsGBAnHk5FxgwBdOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574300; c=relaxed/simple;
	bh=8U8b6ZZ582ffljalWmb0PGooxF7abQX23dgQ1ppN3Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hzny6JG/M/g47Q5Nyk0Y2BVlcyhb6g9vc6njaQyXxH9B2KSyKsliOqA0yqueqfcqaOsXmmhD4NAP/ENbKXjkp9lvB55OLb06xvbR/oWDgRVIQpdWoTCUFrk1DemdABW81XvCR4jU/vglGX2wG2qE055P2vnSPjHAWqChVI5HBvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2TgEsbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2TgEsbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1781FC4CED0;
	Mon, 30 Dec 2024 15:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574300;
	bh=8U8b6ZZ582ffljalWmb0PGooxF7abQX23dgQ1ppN3Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2TgEsbARSVeZa9dzxQpiBaUDzSj3S5SdnRRIYPdUqoAhbzi6JoEbVLSkqTODfaHH
	 Hw1cLudv9ltErdQUdhgZcF8Ah3Cj9FDTMCY2Ibs1DR/epKOnIYCgrmLKI4LN/fY2Ez
	 1e9GqvID18O8nnGYqwBU6hnppb9ZzgYgSbOGMo8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.12 096/114] perf/x86/intel/ds: Add PEBS format 6
Date: Mon, 30 Dec 2024 16:43:33 +0100
Message-ID: <20241230154221.801336182@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit b8c3a2502a205321fe66c356f4b70cabd8e1a5fc upstream.

The only difference between 5 and 6 is the new counters snapshotting
group, without the following counters snapshotting enabling patches,
it's impossible to utilize the feature in a PEBS record. It's safe to
share the same code path with format 5.

Add format 6, so the end user can at least utilize the legacy PEBS
features.

Fixes: a932aa0e868f ("perf/x86: Add Lunar Lake and Arrow Lake support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241216204505.748363-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2496,6 +2496,7 @@ void __init intel_ds_init(void)
 			x86_pmu.large_pebs_flags |= PERF_SAMPLE_TIME;
 			break;
 
+		case 6:
 		case 5:
 			x86_pmu.pebs_ept = 1;
 			fallthrough;


