Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE38D819
	for <patches@lists.linux.dev>; Tue, 24 May 2022 13:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7786CC385AA;
	Tue, 24 May 2022 13:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1653400378;
	bh=STLMhacHl2AWzy+G9RHYcojTiEvQVA6j5evH9G5s9Zk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aEEVfvhTm/iy3uXXblT6eftV1oQ2Mqfmu5UZXpotce+AeLjMCEvLhcLq1NsAsx/mF
	 9aOQyRAExiU3mqg+ztMj7KMAEvhotfcsymhln6gUjTpbSOzbYZRkhloVofrFPHyhPK
	 H16n/uM1p5rW2jsGTk4+a3XQ9/bNdJCdIlC36l5BXqVwXCPfQCHdcyGAktMfhfAFWn
	 9DGUkubUzDs8TPErx1UAkMRyTv8q9awK5O9U0vLaxyUxRtX2IHOsfQ0l0WF4tXqx7z
	 +nxV/EuMPRIbdXyYZu2z6ycToGbqYucrk6oz9gjdwpQujyZrTp7InX9LMW7jWq+RTu
	 CcoH1YQvrjEgQ==
Date: Tue, 24 May 2022 19:22:50 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Prasad Sodagudi <quic_psodagud@quicinc.com>,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] mailbox: qcom-ipcc: Fix -Wunused-function with
 CONFIG_PM_SLEEP=n
Message-ID: <20220524135250.GC5745@thinkpad>
References: <20220523224702.2002652-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220523224702.2002652-1-nathan@kernel.org>

On Mon, May 23, 2022 at 03:47:02PM -0700, Nathan Chancellor wrote:
> When CONFIG_PM_SLEEP is not set, there is a warning that
> qcom_ipcc_pm_resume() is unused:
> 
>   drivers/mailbox/qcom-ipcc.c:258:12: error: 'qcom_ipcc_pm_resume' defined but not used [-Werror=unused-function]
>     258 | static int qcom_ipcc_pm_resume(struct device *dev)
>         |            ^~~~~~~~~~~~~~~~~~~
>   cc1: all warnings being treated as errors
> 
> Commit 1a3c7bb08826 ("PM: core: Add new *_PM_OPS macros, deprecate old
> ones") reworked the PM_OPS macros to avoid this problem. Use
> NOIRQ_SYSTEM_SLEEP_PM_OPS directly so that qcom_ipcc_pm_resume() always
> appears to be used to the compiler, even though it will be dead code
> eliminated in the !CONFIG_PM_SLEEP case.
> 
> Fixes: c25f77899753 ("mailbox: qcom-ipcc: Log the pending interrupt during resume")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

My bad, I missed this. Thanks for the fix!

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

Thanks,
Mani

> ---
>  drivers/mailbox/qcom-ipcc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mailbox/qcom-ipcc.c b/drivers/mailbox/qcom-ipcc.c
> index 2583b20cdeb7..31d58b7d55fe 100644
> --- a/drivers/mailbox/qcom-ipcc.c
> +++ b/drivers/mailbox/qcom-ipcc.c
> @@ -344,7 +344,7 @@ static const struct of_device_id qcom_ipcc_of_match[] = {
>  MODULE_DEVICE_TABLE(of, qcom_ipcc_of_match);
>  
>  static const struct dev_pm_ops qcom_ipcc_dev_pm_ops = {
> -	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(NULL, qcom_ipcc_pm_resume)
> +	NOIRQ_SYSTEM_SLEEP_PM_OPS(NULL, qcom_ipcc_pm_resume)
>  };
>  
>  static struct platform_driver qcom_ipcc_driver = {
> 
> base-commit: bca1a1004615efe141fd78f360ecc48c60bc4ad5
> -- 
> 2.36.1
> 

-- 
மணிவண்ணன் சதாசிவம்
