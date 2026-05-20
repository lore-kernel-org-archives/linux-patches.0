Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EE23F23B5;
	Wed, 20 May 2026 11:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276048; cv=none; b=G07XYmiUuSZr148vYTP1lyrr8GORvYPeP5667EbmlAcgPdWWAX8lpjBSfylCAjUipETHRoD83woMWEWhbMLyYNA6TAMeubBcIOlVTeK1CnTtck/raSXaICL/YzQcvhMOfmwgpk0WgebwrqoFqLwup+v0TsKivGbh1L5eDkob+Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276048; c=relaxed/simple;
	bh=1Oxyfd1/v7O27frv8bMTIM++jJRA0r8gE2wj5UKC5ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hgF0hrheDjKQJYO+xJPUh+RQ7DQDuN0p7ZQcXd53ezvO8Ngvbr/xpjf3iH22gT7lQ0jxQQgzqeRLxmSUUmWWzExv11NhegZuaQMFvNsm9Ta3Cy6pR8RBjmRidab2chIXFmaxAE5iUpDctPoQC7SS3OVijVNa86tZz32v2+fyf78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JodNbaba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JodNbaba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D9A1F000E9;
	Wed, 20 May 2026 11:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276046;
	bh=t9GJjxz7MXEZbqV6+5d9dAOL2Akoh9f4mOaXvcGs6WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JodNbabahQ4KYNtVtaEeBI4WLvAJ/LGW2bWd64MPM8do1ht2NHdkP6+pUwVEkSnGc
	 4x4wkRN+xAdjUVeK+rOhWvKzJqngVW8TN6jq5mN8OfujT12OtLkPxPOv4RLRBTl2Bz
	 ZDDe5ePuZWLHr063elD3jN+l1gZjzuprCfnfLLoVcVGIUKKHvxhwRdnexsrAKLzoZ2
	 PQwapcqW/eEBrp4VlGnOtABMC5rvTDsghWaKGxZjK18fR1vPntGb02pxyp0jzNHaCm
	 3anYNVPhLafF/SJQaT8/PhHre5wsRmiIiQNShU6dQ/E+XXabMYjlp8nB/3wz6+Ptlh
	 +4iRUfbEyw9RQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	Frank.Li@nxp.com,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] fbdev: ipu-v3: clean up kernel-doc warnings
Date: Wed, 20 May 2026 07:19:15 -0400
Message-ID: <20260520111944.3424570-43-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit f1fb23a0a0fcbdb66672da51d7d63a259f6396ca ]

Correct all kernel-doc warnings:
- fix a typedef kernel-doc comment
- mark a list_head as private
- use Returns: for function return values

Warning: include/video/imx-ipu-image-convert.h:31 struct member 'list' not
 described in 'ipu_image_convert_run'
Warning: include/video/imx-ipu-image-convert.h:40 function parameter
 'ipu_image_convert_cb_t' not described in 'void'
Warning: include/video/imx-ipu-image-convert.h:40 expecting prototype for
 ipu_image_convert_cb_t(). Prototype was for void() instead
Warning: include/video/imx-ipu-image-convert.h:66 No description found for
 return value of 'ipu_image_convert_verify'
Warning: include/video/imx-ipu-image-convert.h:90 No description found for
 return value of 'ipu_image_convert_prepare'
Warning: include/video/imx-ipu-image-convert.h:125 No description found for
 return value of 'ipu_image_convert_queue'
Warning: include/video/imx-ipu-image-convert.h:163 No description found for
 return value of 'ipu_image_convert'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: subsystem `fbdev: ipu-v3`; action verb `clean up`;
intent is to correct kernel-doc warnings in `include/video/imx-ipu-
image-convert.h`.

Step 1.2 Record: tags in committed message are `Signed-off-by: Randy
Dunlap <rdunlap@infradead.org>`, `Reviewed-by: Philipp Zabel
<p.zabel@pengutronix.de>`, and `Signed-off-by: Helge Deller
<deller@gmx.de>`. No `Fixes:`, `Reported-by:`, `Tested-by:`, `Acked-
by:`, `Link:`, or `Cc: stable@vger.kernel.org` tag is present in the
committed message.

Step 1.3 Record: the described problem is seven kernel-doc warnings: one
undocumented/private list member, malformed typedef documentation, and
missing `Returns:` sections. The visible symptom is documentation
tooling warnings, not a runtime crash, hang, data corruption, or
security issue. No affected kernel version is stated. Root cause is
incorrect kernel-doc comment syntax.

Step 1.4 Record: this is not a hidden runtime bug fix. The body and diff
both show a documentation/comment-only cleanup.

## Phase 2: Diff Analysis
Step 2.1 Record: one file changed: `include/video/imx-ipu-image-
convert.h`, 11 insertions and 5 deletions. Modified documentation covers
`struct ipu_image_convert_run`, `ipu_image_convert_cb_t`,
`ipu_image_convert_verify()`, `ipu_image_convert_prepare()`,
`ipu_image_convert_queue()`, and `ipu_image_convert()`. Scope is single-
file, header-only, surgical.

Step 2.2 Record: hunk behavior:
- `struct ipu_image_convert_run`: before, `list` was documented neither
  as a member nor private; after, `/* private: */` tells kernel-doc to
  ignore it as an API member.
- `ipu_image_convert_cb_t`: before, kernel-doc treated the typedef
  comment as a function prototype mismatch; after, it is marked as a
  typedef comment.
- Return docs: before, several returns were plain prose or missing;
  after, they use kernel-doc `Returns:` syntax.
- `ipu_image_convert_prepare()`: before, the V4L2 usage note followed
  the return prose; after, the return section is last and formatted for
  kernel-doc.

Step 2.3 Record: bug category is documentation/kernel-doc warning
cleanup. No error-path, synchronization, refcount, memory-safety,
initialization, type, logic, or hardware workaround change exists.

Step 2.4 Record: fix quality is high for the stated documentation issue:
small, obviously correct kernel-doc syntax changes. Runtime regression
risk is effectively zero because no C declarations, types, function
bodies, data layout, or APIs are changed. Documentation rendering risk
is very low.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` shows the affected header comments and
declarations came from `cd98e85a6b786d` by Steve Longerbeam, dated
2016-09-17. `git describe --contains cd98e85a6b786d` reports it as
present by `v4.9-rc1~41^2~24^2`.

Step 3.2 Record: no `Fixes:` tag is present, so there is no tagged
introducing commit to follow. Blame identifies `cd98e85a6b786d` as the
source of the documented preimage; `git show` confirms that commit added
queued IPU image conversion support and the API documentation.

Step 3.3 Record: recent local history for the file shows `96e9d754b35e8`
removing unused `ipu_image_convert_*` functions, `c942fddf8793b` adding
SPDX boilerplate conversion, and `cd98e85a6b786d` adding the header/API.
No prerequisite commit is needed for this documentation-only patch.

Step 3.4 Record: `git log --author='Randy Dunlap'` under fbdev/include
areas shows Randy has related cleanup/documentation work such as `fbdev:
hgafb: fix kernel-doc comments` and `fbdev: fbmon: fix function name in
kernel-doc`. The patch was reviewed by Philipp Zabel and committed by
Helge Deller, verified from the commit and lore thread.

Step 3.5 Record: no dependencies found. The diff changes only comments
and applies locally with `git apply --check`.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c f1fb23a0a0fcbdb66672da51d7d63a259f6396ca`
failed to find a lore match by patch-id, author/subject, or in-body
From. External fetch found the v3 discussion at
`https://yhbt.net/lore/dri-
devel/20260427183236.656902-1-rdunlap@infradead.org/T/`. The v3 thread
has Helge Deller replying “applied to fbdev git tree.” Web search/fetch
also found v2 and a v2 ping. No NAKs or objections were found.

Step 4.2 Record: `b4 dig -w` also failed for the same reason. The v3
lore mirror shows recipients included `dri-devel`, Philipp Zabel, DRM
maintainers, `imx`, `linux-arm-kernel`, Helge Deller, and `linux-fbdev`.

Step 4.3 Record: no `Reported-by:` or bug-report `Link:` tags exist. No
external crash/security bug report applies.

Step 4.4 Record: this is a standalone one-patch documentation cleanup.
v2 added the reviewed-by and updated Cc list; v3 rebased and resent.

Step 4.5 Record: direct `lore.kernel.org/stable` fetch was blocked by
Anubis. Web search for the exact subject plus `stable` found patch-
thread results but no stable-specific discussion or stable nomination.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: modified documented symbols are
`ipu_image_convert_run`, `ipu_image_convert_cb_t`,
`ipu_image_convert_verify()`, `ipu_image_convert_prepare()`,
`ipu_image_convert_queue()`, and `ipu_image_convert()`.

Step 5.2 Record: `rg` found callers in `drivers/staging/media/imx/imx-
media-csc-scaler.c` for `ipu_image_convert_abort()`,
`ipu_image_convert_queue()`, `ipu_image_convert_adjust()`,
`ipu_image_convert_unprepare()`, and `ipu_image_convert_prepare()`.
Runtime callers are unaffected because only comments changed.

Step 5.3 Record: reading `drivers/gpu/ipu-v3/ipu-image-convert.c`
confirms the documented functions perform image format
adjustment/verification, context allocation, queueing, abort/unprepare,
and single conversion setup. None of those function bodies are touched.

Step 5.4 Record: runtime path is reachable through IPU image conversion
users, but the patch changes no runtime path. The affected path for the
fix is kernel-doc/documentation generation.

Step 5.5 Record: no related same-header kernel-doc fix was found by `git
log --grep='kernel-doc' -- include/video/imx-ipu-image-convert.h`.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: version tags `v5.10`, `v5.15`, `v6.1`, `v6.6`, `v6.12`,
`v6.15`, `v6.16`, and `v6.17` all contain `include/video/imx-ipu-image-
convert.h` with the old kernel-doc text. The API was introduced before
`v4.9-rc1`, so active stable trees checked contain the documentation
issue.

Step 6.2 Record: expected backport difficulty is clean or minor. `git
apply --check` succeeds against the current local tree, and the checked
stable tags contain representative preimage lines. Full per-stable
worktree application was not run.

Step 6.3 Record: no related stable fix for this header was found in
local `git log --grep` searches.

## Phase 7: Subsystem Context
Step 7.1 Record: subsystem is fbdev/gpu IPU-v3 image conversion
documentation in an include header. Runtime criticality is
peripheral/driver-specific; documentation-build criticality is low.

Step 7.2 Record: local subsystem history shows ongoing cleanup/removal
activity in `drivers/gpu/ipu-v3` and the header, including unused-
function removals and treewide cleanup. This patch is not part of a
required functional series.

## Phase 8: Impact And Risk
Step 8.1 Record: affected population is kernel documentation builders,
maintainers, and users consuming generated kernel-doc. Runtime users of
IPU-v3 are not affected by behavior.

Step 8.2 Record: trigger is running kernel-doc/documentation tooling
over this header. It is not triggered by boot, device probe, syscalls,
or ordinary runtime use. Unprivileged runtime trigger does not apply.

Step 8.3 Record: failure mode is documentation warnings only. Severity
is LOW. I did not verify any configuration where these warnings are
fatal, so that does not drive the decision.

Step 8.4 Record: benefit is low but real under the documentation-fix
exception: it makes stable documentation builds cleaner. Risk is
extremely low because only comments change. Risk/benefit is favorable if
stable accepts documentation corrections.

## Phase 9: Final Synthesis
Step 9.1 Record: evidence for backporting: pure documentation
correction, explicitly fixes listed kernel-doc warnings, tiny single-
file patch, reviewed by Philipp Zabel, applied by Helge Deller, old text
exists in active stable tags checked, and documentation/comment fixes
are an allowed stable exception. Evidence against: no runtime bug, no
crash/security/data-corruption impact, no stable nomination found, and
b4 could not match the thread. Unresolved: direct stable-lore search was
blocked; full apply checks on every stable branch were not run.

Step 9.2 Record:
1. Obviously correct and tested? Mostly yes for documentation syntax;
   reviewed and applied, but no `Tested-by`.
2. Fixes a real bug that affects users? Yes, a real kernel-doc warning
   issue; not a runtime bug.
3. Important issue? No runtime severity; LOW documentation-build
   severity.
4. Small and contained? Yes, 11 additions and 5 deletions in one header.
5. No new features or APIs? Yes, comments only.
6. Can apply to stable trees? Likely yes; local apply check passed and
   stable tags checked contain the preimage.

Step 9.3 Record: exception category applies: documentation/comment fix.
This is the main reason to accept despite lack of runtime impact.

Step 9.4 Decision: backporting is appropriate under the stable
documentation-fix exception. It is not a stability/security fix, but it
is a correct, reviewed, zero-runtime-risk cleanup of real kernel-doc
warnings in code present across active stable trees.

## Verification
- Phase 1: fetched and inspected committed metadata for
  `f1fb23a0a0fcbdb66672da51d7d63a259f6396ca`; confirmed tags and
  message.
- Phase 2: `git show --stat --patch` confirmed one header, 11
  insertions, 5 deletions, comments only.
- Phase 3: `git blame` confirmed changed comment preimage from
  `cd98e85a6b786d`; `git describe --contains` placed it before
  `v4.9-rc1`; `git show cd98e85a6b786d` confirmed original API addition.
- Phase 3: `git log` on the header/subsystem found no prerequisite
  functional series.
- Phase 4: `b4 dig`, `b4 dig -a`, and `b4 dig -w` all failed to match;
  recorded as a tool limitation/failure.
- Phase 4: WebFetch of the v3 lore mirror confirmed the patch thread and
  Helge Deller’s applied reply; Spinics fetch confirmed v2 and a later
  ping.
- Phase 5: `rg` found runtime users; `ReadFile` of implementation
  confirmed function bodies exist but are not changed.
- Phase 6: tag checks confirmed the header and old doc text in `v5.10`,
  `v5.15`, `v6.1`, `v6.6`, `v6.12`, `v6.15`, `v6.16`, and `v6.17`; `git
  apply --check` succeeded locally.
- Phase 8: severity/risk assessment is derived from the verified
  comments-only diff.
- UNVERIFIED: direct `lore.kernel.org/stable` search content was blocked
  by Anubis; no actual `make htmldocs` run was performed; full patch
  application against every individual stable branch was not performed.

**YES**

 include/video/imx-ipu-image-convert.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/video/imx-ipu-image-convert.h b/include/video/imx-ipu-image-convert.h
index 003b3927ede5c..6b77968a6a150 100644
--- a/include/video/imx-ipu-image-convert.h
+++ b/include/video/imx-ipu-image-convert.h
@@ -27,12 +27,13 @@ struct ipu_image_convert_run {
 
 	int status;
 
+	/* private: */
 	/* internal to image converter, callers don't touch */
 	struct list_head list;
 };
 
 /**
- * ipu_image_convert_cb_t - conversion callback function prototype
+ * typedef ipu_image_convert_cb_t - conversion callback function prototype
  *
  * @run:	the completed conversion run pointer
  * @ctx:	a private context pointer for the callback
@@ -60,7 +61,7 @@ void ipu_image_convert_adjust(struct ipu_image *in, struct ipu_image *out,
  * @out:	output image format
  * @rot_mode:	rotation mode
  *
- * Returns 0 if the formats and rotation mode meet IPU restrictions,
+ * Returns: 0 if the formats and rotation mode meet IPU restrictions,
  * -EINVAL otherwise.
  */
 int ipu_image_convert_verify(struct ipu_image *in, struct ipu_image *out,
@@ -77,11 +78,11 @@ int ipu_image_convert_verify(struct ipu_image *in, struct ipu_image *out,
  * @complete:	run completion callback
  * @complete_context:	a context pointer for the completion callback
  *
- * Returns an opaque conversion context pointer on success, error pointer
+ * In V4L2, drivers should call ipu_image_convert_prepare() at streamon.
+ *
+ * Returns: an opaque conversion context pointer on success, error pointer
  * on failure. The input/output formats and rotation mode must already meet
  * IPU retrictions.
- *
- * In V4L2, drivers should call ipu_image_convert_prepare() at streamon.
  */
 struct ipu_image_convert_ctx *
 ipu_image_convert_prepare(struct ipu_soc *ipu, enum ipu_ic_task ic_task,
@@ -122,6 +123,8 @@ void ipu_image_convert_unprepare(struct ipu_image_convert_ctx *ctx);
  * In V4L2, drivers should call ipu_image_convert_queue() while
  * streaming to queue the conversion of a received input buffer.
  * For example mem2mem devices this would be called in .device_run.
+ *
+ * Returns: 0 on success or -errno on error.
  */
 int ipu_image_convert_queue(struct ipu_image_convert_run *run);
 
@@ -155,6 +158,9 @@ void ipu_image_convert_abort(struct ipu_image_convert_ctx *ctx);
  * On successful return the caller can queue more run requests if needed, using
  * the prepared context in run->ctx. The caller is responsible for unpreparing
  * the context when no more conversion requests are needed.
+ *
+ * Returns: pointer to the created &struct ipu_image_convert_run that has
+ * been queued on success; an ERR_PTR(errno) on error.
  */
 struct ipu_image_convert_run *
 ipu_image_convert(struct ipu_soc *ipu, enum ipu_ic_task ic_task,
-- 
2.53.0

