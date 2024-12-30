Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C90215E8B;
	Mon, 30 Dec 2024 15:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574320; cv=none; b=vD0RkP0a/X1yMNu6jXzmDCkhB2W1vXRU69K07psmGdBjDI9osbWzlR3aQ4xXozEkD/yeKTdqj4dKn3Y32GF86uU7HxTeBjsqxdjy0j4hbo1aXwQuGZlnw5R7Ue3r+EhaEqhi90z7x74kUxwrWN19jn9xIrideWC43C9SudBmg7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574320; c=relaxed/simple;
	bh=2XhbkX8Dhp2JQ1OfI4BR8hw2ke9zP7d/Pub+6P0v97o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEx7BxUSwRfhvW4uToNm5eZpFrFD5f9+co9/QKKU/ywe/5dR+TrhYRtu+VrJ6vz8VL6uzlGJoe21qWTLnA8KsDPz4x9GMD0nq2o1Jjme2z2fgULuU5aIPOiagiqklRVsFi13IsGwM6gfy3kfQx0ZtnGElp5O4EgqVwhnGND5qYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pULlE3OT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pULlE3OT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB75C4CED0;
	Mon, 30 Dec 2024 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574319;
	bh=2XhbkX8Dhp2JQ1OfI4BR8hw2ke9zP7d/Pub+6P0v97o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pULlE3OTB2JJz4CKEmOSLKbjfjXaeXEt1DgqXj+ErMELkGuARKwh5EVnRcmQLxSpJ
	 pxSCISHjOwNduvL6ZOzzja3qS/TAckLni7qh84B9kLUphl0Eeyw5MlvhOjpMUvCxE+
	 BTZ6ikcxJFRybO8FkBQNmYTJAw42Rrdefm4I7lYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.12 084/114] perf/x86/intel/uncore: Add Clearwater Forest support
Date: Mon, 30 Dec 2024 16:43:21 +0100
Message-ID: <20241230154221.325856889@linuxfoundation.org>
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

commit b6ccddd6fe1fd49c7a82b6fbed01cccad21a29c7 upstream.

>From the perspective of the uncore PMU, the Clearwater Forest is the
same as the previous Sierra Forest. The only difference is the event
list, which will be supported in the perf tool later.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20241211161146.235253-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1910,6 +1910,7 @@ static const struct x86_cpu_id intel_unc
 	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT,	&adl_uncore_init),
 	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X,	&gnr_uncore_init),
 	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT,	&gnr_uncore_init),
+	X86_MATCH_VFM(INTEL_ATOM_DARKMONT_X,	&gnr_uncore_init),
 	{},
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_uncore_match);


